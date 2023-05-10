
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:importify/main.dart';
import 'package:importify/utils/auth.dart';
import '../redux/redux.dart';

// set access token in redux store
void setAccessToken(String accessToken, UserType userType){
  switch (userType) {
    case UserType.import:
      store.dispatch(SetImportUserAccessToken(accessToken));
      break;
    case UserType.export:
      store.dispatch(SetExportUserAccessToken(accessToken));
      break;
    default:
  }
}

void getProfileDetails(UserType userType){
  switch (userType) {
    case UserType.import:
      if (store.state.import.accessToken == '') {
        throw Exception('Access token not set');
      }
      break;
    case UserType.export:
      if (store.state.export.accessToken == '') {
        throw Exception('Access token not set');
      }
      break;
    default:
  }
}

// get url search parameters for Spotify Login
Uri getSpotifyLoginUri(UserType userType) {
  Map<String,dynamic> params = {};
  String clientId = '', port = '';

  PkcePair pkcePair = PkcePair.generateAndStoreInRedux(userType: userType);
  String challenge = pkcePair.challenge;

  if (dotenv.env['client_id'] != null) {
    clientId = dotenv.env['client_id']!;
  }

  if (dotenv.env['port'] != null) {
    port = dotenv.env['port']!;
  }

  params['client_id'] = clientId;
  params['response_type'] = 'code';
  params['redirect_uri'] = 'http://localhost:$port/callback';
  params['scope'] = 'user-read-private user-read-email';
  params['code_challenge_method'] = 'S256';
  params['code_challenge'] = challenge;

  Uri uri = Uri.https('accounts.spotify.com', '/authorize', params);
  return uri;
}
