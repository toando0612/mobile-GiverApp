import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giver_app/UI/views/qr_scan_view.dart';
import 'package:giver_app/UI/widgets/coupon_status.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';

class CouponItem extends StatefulWidget {
  final Function() onRedeemed;

  const CouponItem({
    @required this.couponItem,
    @required this.onRedeemed,
    @required this.customer,
  });

  final Coupon couponItem;
  final User customer;

  @override
  _CouponItemState createState() => _CouponItemState();
}

class _CouponItemState extends State<CouponItem> {
  double _height = 70.0;
  static const double descriptionPadding = 15.0;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
      width: double.infinity,
      height: _height,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: Colors.grey),
      child: Row(
        children: <Widget>[_detailSection, _redeemButton],
      ),
    );
  }


  Widget get _redeemButton => Container(
      width: 200,
      child: Column(children: <Widget>[
        (widget.couponItem.usedBy.isEmpty)
            ? FlatButton( 
                child: Text('Use Coupon'), onPressed: () {setState(() {
                  widget.onRedeemed; 
                });}
                )
            : Container(),
        Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('Today',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 9))))
      ]));

  Widget get _detailSection => Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              print('tap' + _showDetails.toString());
              _showDetails = !_showDetails;
              if (_showDetails) {
                _height = 150.0;
              } else {
                _height = 80.0;
              }
            });
          },
          child: Container(
            color: Colors.grey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.couponItem.description,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _showDetails
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: descriptionPadding),
                        child: Text(widget.couponItem.ownedBy),
                      )
                    : Container(),
                Expanded(
                    child: Align(
                        child: CouponStatus(status: ( widget.couponItem.isUsed ? 3 : widget.couponItem.isPending ? 2 : 1)),
                        alignment: Alignment.bottomLeft))
              ],
            ),
          ),
        ),
      );
}
