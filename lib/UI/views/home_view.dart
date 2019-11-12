import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/scoped_model/home_view_model.dart';
import 'base_view.dart';
import 'customer_home_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, child, model) => Container(
        child: _getbody(model),
      ),
    );
  }

  Widget _getbody(HomeViewModel model) {
    var currentUser = model.getCurrentUser(model.users, widget.user.uid);
    switch (currentUser.level) {
      case 1:
        return CustomerHomeView(user: currentUser);
      case 2:
        return MerchantHomeView(user: currentUser);
      default:
        return Text('Cannot load page');
    }
  }
}
