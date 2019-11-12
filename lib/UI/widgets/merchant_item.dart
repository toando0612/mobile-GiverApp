import 'package:flutter/material.dart';
import 'package:giver_app/UI/views/merchant_profile_view.dart';
import 'package:giver_app/model/user.dart';

class MerchantItem extends StatelessWidget {
  final User merchant;
  final User customer;
  MerchantItem({@required this.merchant, @required this.customer});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200.0,
        padding: EdgeInsets.all(10.0),
        child: Container(
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MerchantProfileView(
                              merchant: merchant, customer: customer))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // add this
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: merchant.imageUrl==null||merchant.imageUrl==''?Image.asset('assets/merchant.jpg', fit: BoxFit.fill,):Image.network(merchant.imageUrl,
                              fit: BoxFit.fill),
                        ),
                        flex: 8,
                      ),
                      Expanded(
                        child: Center(child: Text(merchant.username)),
                        flex: 2,
                      ),
                    ],
                  ),
                ))));
  }
}
