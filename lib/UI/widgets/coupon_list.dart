import 'package:flutter/material.dart';
import 'package:giver_app/UI/views/edit_coupon_page.dart';
import 'package:giver_app/model/coupon.dart';

class CouponList extends StatefulWidget {
  CouponList({@required this.couponList});
  final List<Coupon> couponList;

  @override
  _CouponListState createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
//            child: CouponListView(couponList: widget.couponList),
          )
        ],
      ),
    );
  }
}
