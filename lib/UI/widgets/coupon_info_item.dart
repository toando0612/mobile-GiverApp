import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/draw_horizontal_line.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';

class CouponInfoItem extends StatefulWidget {
  const CouponInfoItem({@required this.merchant, @required this.coupon, @required this.onRedeemed});
  final User merchant;
  final Coupon coupon;
  final Function() onRedeemed;
  
  @override
  _CouponInfoItemState createState() => _CouponInfoItemState();
}

class _CouponInfoItemState extends State<CouponInfoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(  
      margin: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[_getCouponInfoBody(), _getCouponInfoHeader()],
      ),
    );
  }

  Widget _getCouponInfoHeader() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        alignment: FractionalOffset.topCenter,
        child: Hero(
          tag: "tag",
          child: Image(
            image: AssetImage("assets/logo.png"),
            height: 92,
            width: 92,
          ),
        ));
  }

  Widget _getCouponInfoBody() {
    return Container(
      constraints: BoxConstraints.expand(),
      margin: EdgeInsets.only(top: 46),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 80,
          ),
          Text(
            widget.merchant.username,
            style: Style.headerTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            height: 10,
          ),
          Text(
            widget.merchant.address, 
            style: Style.commonTextStyle,
            textAlign: TextAlign.center,
          ),

          Container(
            height: 20,
          ),
          Container(
            height: 20,
            child: CustomPaint(
              painter: DrawHorizontalLine(),
            ),
          ),
          Text(
            "Coupon Code",
            style: Style.commonTextStyle,
          ),
          Container(
            height: 30,
          ),
          Text(
            widget.coupon.code,
            style: Style.couponCodeTextStyle,
          ),
          Container(
            height: 30,
          ),
          Text(
            widget.coupon.description,
            style: Style.commonTextStyle,
            textAlign: TextAlign.center,
          ),
          Container(
            height: 30,
          ),
          ButtonTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            minWidth: 200,
            child: RaisedButton(
              child: Text(
                "Redeem Now",
                style: Style.infoTextStyle,
              ),
              onPressed: widget.onRedeemed,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
