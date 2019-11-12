import 'package:flutter/material.dart';
import '../../model/user.dart';
import '../../scoped_model/user_home_view_model.dart';
import 'merchant_item.dart';

class MerchantList extends StatefulWidget {
  final User customer;
  final UserHomeViewModel model;
  MerchantList({@required this.model, @required this.customer});
  @override
  _MerchantListState createState() => _MerchantListState();
}

class _MerchantListState extends State<MerchantList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        
        Expanded(
          child: ListView.builder(
              itemCount: widget.model.merchants.length,
              itemBuilder: (context, rowNumber) {
                var merchants = widget.model.merchants;
                var merchant = merchants[rowNumber];
                print('merchant item:');
                return MerchantItem(
                    merchant: merchant, customer: widget.customer);
              }),
          flex: 9,
        ),
      ],
    );
  }
}
