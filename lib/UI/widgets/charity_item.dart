import 'package:flutter/material.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'charity_info.dart';

class CharityItem extends StatelessWidget {
  final BuildContext context;
  final UserHomeViewModel model;
  final User customer;
  final Charity charity;

  CharityItem({@required this.context,@required this.model,@required this.customer, @required this.charity});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200.0,
        padding: EdgeInsets.all(10.0),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CharityInfo(context: context, model: model,
                          customer: customer, charityId: charity.id))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // add this
                children: <Widget>[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image.network(charity.imageUrl,
                          // width: 300,
                          fit: BoxFit.fill),
                    ),
                    flex: 8,
                  ),
                  Expanded(
                    child: Center(child: Text(charity.name)),
                    flex: 2,
                  ),
                ],
              ),
            )));
  }
}
