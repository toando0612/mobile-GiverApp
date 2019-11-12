import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class MerchantHistoryEntry extends StatelessWidget {

  const MerchantHistoryEntry({@required this.coupon, this.usedBy});

  final Coupon coupon;
  final String usedBy;
  
  @override
  Widget build(BuildContext context) {
    DateTime time = coupon.time.toDate();
    var date = formatDate(time, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);
    return Container(
      height: 190,
      child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1),
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10.0),
          elevation: 15.0,
//                color: Colors.cyanAccent,
//            height: 155,
//            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
          child: Column(
            children: <Widget>[
              //header
              Container(
                margin: EdgeInsets.only(bottom: 3, right: 10, top: 10),
                alignment: Alignment.bottomRight,
                child: Text(
                  date,
                  style: Style.couponHistoryTextStyle,
                ),
              ),
              Divider(
                color: Colors.black,
                height: 15,
              ),
              //body
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Text(coupon.code,
                          style: Style.couponHistoryTextStyleBigger),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10, left: 10, bottom: 5),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text("Description:",
                              style: Style.couponHistoryTextStyle),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 10, left: 20, bottom: 5),
                        ),
                        Expanded(flex: 5,
                                                  child: Container(
                            child: Text(coupon.description,
                                style: Style.couponHistoryTextStyle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,),
                            alignment: Alignment.centerLeft,  
                            margin: EdgeInsets.only(top: 10, left: 10, bottom: 5),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Points :",
                            style: Style.couponHistoryTextStyle,
                          ),
                          margin: EdgeInsets.only(left: 20, bottom: 5),
                        ),
                        Container(
                          child: Text(
                            coupon.points.toString(),
                            style: Style.couponHistoryTextStyle,
                          ),
                          margin: EdgeInsets.only(left: 10, bottom: 5),
                        ),
                      ],
                    ),
                    Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(
                                left: 20, bottom: 15, right: 10),
                            child: Text("Used by:",
                                style: Style.couponHistoryTextStyle)),
                        Container(
                          margin: EdgeInsets.only(bottom: 15, right: 10),
                          child: Text(usedBy,
                              style: Style.couponHistoryTextStyle),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
