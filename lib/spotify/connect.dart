import 'package:importify/main.dart';
import '../redux/redux.dart';

// set access token in redux store
void setAccessToken(String accessToken, ProfileCardState userType){
  switch (userType) {
    case ProfileCardState.importProfile:
      store.dispatch(SetImportUserAccessToken(accessToken));
      break;
    case ProfileCardState.exportProfile:
      store.dispatch(SetExportUserAccessToken(accessToken));
      break;
    default:
  }
}

void getProfileDetails(ProfileCardState userType){
  switch (userType) {
    case ProfileCardState.importProfile:
      if (store.state.import.accessToken == '') {
        throw Exception('Access token not set');
      }
      break;
    case ProfileCardState.exportProfile:
      if (store.state.export.accessToken == '') {
        throw Exception('Access token not set');
      }
      break;
    default:
  }
}
