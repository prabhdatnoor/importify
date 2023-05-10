import 'package:redux/redux.dart';

Store<AppState> store = Store<AppState>(
  reducer,
  initialState: AppState.initialState(),
);

class User {
  final Map<String, dynamic> profile;
  final String accessToken, verifier, challenge;

  User({this.profile = const {}, this.accessToken = '', this.verifier = '', this.challenge = ''});
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
    case SetImportUserVerifier:
      return AppState(
        import: User(
          verifier: (action as SetImportUserVerifier).verifier,
          profile: state.import.profile,
        ),
        export: state.export,
      );
    case SetImportUserChallenge:
      return AppState(
        import: User(
          challenge: (action as SetImportUserChallenge).challenge,
          profile: state.import.profile,
        ),
        export: state.export,
      );
    case SetExportUserVerifier:
      return AppState(
        import: state.import,
        export: User(
          verifier: (action as SetExportUserVerifier).verifier,
          profile: state.export.profile,
        ),
      );
    case SetExportUserChallenge:
      return AppState(
        import: state.import,
        export: User(
          challenge: (action as SetExportUserChallenge).challenge,
          profile: state.export.profile,
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

class SetImportUserVerifier {
  final String verifier;

  SetImportUserVerifier(this.verifier);
}

class SetImportUserChallenge {
  final String challenge;

  SetImportUserChallenge(this.challenge);
}

class SetExportUserVerifier {
  final String verifier;

  SetExportUserVerifier(this.verifier);
}

class SetExportUserChallenge {
  final String challenge;

  SetExportUserChallenge(this.challenge);
}