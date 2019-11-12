import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../scoped_model/user_home_view_model.dart';
import 'charity_item.dart';

class CharityList extends StatefulWidget {
  final User customer;
  final UserHomeViewModel model;
  CharityList({@required this.model, @required this.customer});
  @override
  _CharityListState createState() => _CharityListState();
}

class _CharityListState extends State<CharityList> {
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var charityList = widget.model.charities;
    return Scaffold(
      body: ListView.builder(
        itemCount: charityList.length,
        itemBuilder: (context, rowNumber) {
          var charityItem = charityList[rowNumber];
          return CharityItem(context: context, model: widget.model,
            customer: widget.customer,
            charity: charityItem,
          );
        },
      ),
    );
  }
}
