import 'package:redux/redux.dart';

Store<AppState> store = Store<AppState>(
  reducer,
  initialState: AppState.initialState(),
);

class User {
  final Map<String, dynamic> profile;
  final String accessToken;

  User({this.profile = const {}, this.accessToken = ''});
}
class AppState {
  final User import, export;

  AppState({ required this.import,  required this.export});

  static AppState initialState() => AppState(
    import: User(),
    export: User(),
  );
}

AppState reducer(AppState state, dynamic action) {
  switch (action.runtimeType) {
    case SetImportUserAccessToken:
      return AppState(
        import: User(
          accessToken: (action as SetImportUserAccessToken).accessToken,
          profile: state.import.profile,
        ),
        export: state.export,
      );
    case SetImportUserProfile:
      return AppState(
        import: User(
          accessToken: state.import.accessToken,
          profile: (action as SetImportUserProfile).profile,
        ),
        export: state.export,
      );
    case SetExportUserAccessToken:
      return AppState(
        import: state.import,
        export: User(
          accessToken: (action as SetExportUserAccessToken).accessToken,
          profile: state.export.profile,
        ),
      );
    case SetExportUserProfile:
      return AppState(
        import: state.import,
        export: User(
          accessToken: state.export.accessToken,
          profile: (action as SetExportUserProfile).profile,
        ),
      );
    default:
      return state;
  }
}

class SetImportUserAccessToken {
  final String accessToken;

  SetImportUserAccessToken(this.accessToken);
}

class SetImportUserProfile {
  final Map<String, dynamic> profile;

  SetImportUserProfile(this.profile);
}

class SetExportUserAccessToken {
  final String accessToken;

  SetExportUserAccessToken(this.accessToken);
}

class SetExportUserProfile {
  final Map<String, dynamic> profile;

  SetExportUserProfile(this.profile);
}