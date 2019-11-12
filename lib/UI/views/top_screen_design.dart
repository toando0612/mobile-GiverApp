import 'package:flutter/material.dart';
import 'package:giver_app/UI/views/add_coupon_page.dart';
import 'package:giver_app/UI/views/custom_shape_clipper.dart';
import 'package:giver_app/model/user.dart';
import 'package:carousel_pro/carousel_pro.dart';

class TopScreenDesign extends StatelessWidget implements PreferredSizeWidget {
  final User user;
  final GlobalKey<ScaffoldState> scaffoldKey;
  TopScreenDesign({@required this.user, this.scaffoldKey});

  final preferredSize = new Size.fromHeight(160.0);
  Color firstColor = Color(0xFF3F51B5);
  Color secondColor = Color(0xFF9C27B0);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 3),
            child: ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [secondColor, firstColor],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.only(top: 30),
                          icon: Icon(Icons.sort),
                          onPressed: () =>
                              scaffoldKey.currentState.openDrawer(),
                          color: Colors.white,
                          iconSize: 28.0,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20,top: 30),
                            child: Text(
                              '${user.username}',
                              style: TextStyle(fontSize: 30, color: Colors.greenAccent),
                            ),
                          ),
                          flex: 5,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      size: 30,
                                    ),
                                    onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddCoupon(user: user)))),
                              ),
                              Text('Add new coupon'),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          // Container(
          //   width: 350,
          //   alignment: Alignment.topCenter,
          //   padding: EdgeInsets.only(top: 90, right: 20.0, left: 70.0),
          //   child: Carousel(
          //     images: [
          //       NetworkImage(
          //           'https://www.kfc.com.au/sites/default/files/WEBSITE_CATERING_768x432px_V2.jpg'),
          //       NetworkImage(
          //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqWibJNYq3NL83RDe__GPE0vQAmhLr788XyZGbCqnWe00NliLa'),
          //       NetworkImage(
          //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsCB6Ul9W22Fsrvi9YJroYmZCjBz8Y5VY3UAY9P0Z4sGiwxuJbyQ')
          //     ],
          //     autoplay: true,
          //     animationCurve: Curves.easeInOutBack,
          //     animationDuration: Duration(microseconds: 500),
          //     overlayShadowSize: 0.7,
          //     dotSize: 4.0,
          //     indicatorBgPadding: 5.0,
          //   ),
          // ),
        ],
      ),
    );
  }
}
