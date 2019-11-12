import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/service_locator.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/services/firebase_service.dart';

export 'package:giver_app/enum/view_state.dart';




import 'base_model.dart';

class HomeViewModel extends BaseModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  List<User> users;
  
  HomeViewModel() {
    _firebaseService.users.listen(_onUserAdded);
  }



  void _onUserAdded(List<User> user) {
    setState(ViewState.Busy);
    users = user;
    if (users == null) {
      setState(ViewState.Busy);
    } else {
      setState(users.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }

  User getCurrentUser(List<User> userList, String id) {
    User currentUser;
    for (User user in userList){
      if (user.id == id ){
        currentUser = user;
      }
    }
    return currentUser;
  }
}