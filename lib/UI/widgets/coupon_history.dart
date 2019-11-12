import 'package:flutter/material.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/scoped_model/customer_history_view_model.dart';
import 'coupon_history_item.dart';

class CouponHistory extends StatelessWidget {
  final CustomerHistoryViewModel model;
  final String uid;
  CouponHistory({@required this.model, @required this.uid});

  @override
  Widget build(BuildContext context) {
    List<Coupon> coupons =
        model.getUsedCoupons(model.coupons, uid);
    return Scaffold(
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, rowNumber) {
          var coupon = coupons[rowNumber];
          return CouponHistoryItem(coupon: coupon,);
        },
      ),
    );
  }
}
