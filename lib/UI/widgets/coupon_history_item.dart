import 'package:flutter/material.dart';
import 'package:giver_app/model/coupon.dart';

class CouponHistoryItem extends StatefulWidget {
  final Coupon coupon;

  CouponHistoryItem({@required this.coupon});

  @override
  _CouponHistoryItemState createState() => _CouponHistoryItemState();
}

class _CouponHistoryItemState extends State<CouponHistoryItem> {
  double _height = 70.0;
  static const double descriptionPadding = 15.0;
  bool _showDetails = false;
  @override
  Widget build(BuildContext context) {
    Widget detailSection(String description, int points) {
      return Expanded(
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
            color: Color.fromRGBO(223, 223, 223, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Text(
                          description,
                          maxLines: 1,
                          style:
                              TextStyle(fontSize: 20.0, color: Color.fromRGBO(198, 99, 0, 1.0)),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: _showDetails
                            ? Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  child: Image.network(
                                      'https://miro.medium.com/max/1200/1*ilC2Aqp5sZd1wi0CopD1Hw.png',
                                      // width: 300,
                                      fit: BoxFit.fill),
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 15.0,
                ),
                Expanded(
                  child: _showDetails
                      ? RichText(
                          text: TextSpan(
                            text: 'Credits: ',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: points.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 20.0)),
                            ],
                          ),
                        )
                      : Container(),
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: double.infinity,
      height: _height,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: Color.fromRGBO(223, 223, 223, 1.0)),
      child: Row(
        children: <Widget>[
          detailSection(widget.coupon.description, widget.coupon.points)
        ],
      ),
    );
  }
}
