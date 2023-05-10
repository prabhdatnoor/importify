import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:importify/redux/redux.dart';
import 'package:importify/spotify/connect.dart';
import 'package:importify/utils/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

var cfg = {};

Future main() async {
  await dotenv.load(fileName: "env.yaml");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Importify',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

enum UserType { import, export }

// build login popup for spotify, tell it whether it's an import or export user
Widget _buildLoginPopup(BuildContext context, UserType userType)  {
  Uri requestUri = getSpotifyLoginUri(userType);
  var spotifyLoginController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          final uri = Uri.parse(request.url);

          if (uri.host == 'REDIRECT_URI') {
            // The URL matches the redirect URI, so we can extract the access token
            final accessToken = uri.fragment
                .split('&')
                .firstWhere((element) => element.startsWith('access_token='))
                .split('=')[1];

            // store access token in redux store
            setAccessToken(accessToken, userType);

            // Close the login popup
            Navigator.of(context).pop();

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }))
    ..loadRequest(requestUri);
  return AlertDialog(
    title: const Text('Login with Spotify'),
    content: SizedBox(
      height: 300,
      child: WebViewWidget(controller: spotifyLoginController),
    ),
  );
}

// A profile card that shows the profile picture and name
// if the redux state shows no one is logged in, ask the user to login
// if the redux state shows someone is logged in, show their profile picture and name
class ProfileCard extends StatelessWidget {
  final UserType userType;

  const ProfileCard({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          var name = '';
          var profilePicture = '';
          bool isLoggedIn = true;

          var profile = {};

          var children = <Widget>[
            Text(name),
            Image.network(profilePicture),
            // if logged in, show the more textbox
            if (isLoggedIn) Text(const JsonEncoder().convert(profile)),
          ];

          return GestureDetector(
            onTap: () {
              // open up spotify login page and get access token to string
              // Open webview to spotify login page
              showDialog(
                context: context,
                builder: (context) => _buildLoginPopup(context, userType),
              );
            },
            child: Column(
              children: children,
            ),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text(widget.title),
      ),

      // Body
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // widget that displays the profile picture and name
          // shrink wrapped so that it doesn't take up the whole screen
          children: const <Widget>[
            ProfileCard(userType: UserType.import),
            ProfileCard(userType: UserType.export),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
