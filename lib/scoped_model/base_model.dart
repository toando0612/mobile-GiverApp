import 'package:giver_app/enum/view_state.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  

  void setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }
}