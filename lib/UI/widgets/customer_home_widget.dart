import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/shared/ui_reducers.dart';
import 'package:giver_app/UI/views/coupon_info_view.dart';
import 'package:giver_app/UI/views/customer_home_view.dart';
import 'package:giver_app/UI/views/merchant_list_view.dart';
import 'package:giver_app/UI/widgets/custom_shape_clipper.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';

class CustomerHomeWidget extends StatelessWidget {
  final User customer;
  final List<Coupon> coupons;
  final List<User> merchants;

  const CustomerHomeWidget({this.customer, this.coupons, this.merchants});
  @override
  Widget build(BuildContext context) {
    var preferredSize = new Size.fromHeight(160.0);
    Color firstColor = Color(0xFF3F51B5);
    Color secondColor = Color(0xFF9C27B0);
    User getMerchantFromCoupon(Coupon coupon) {
      for (User user in merchants) {
        if (coupon.ownedBy == user.id) {
          return user;
        }
      }
      return null;
    }

    Widget makeCard(BuildContext context, Coupon coupon) => GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CouponInfoView(
                        coupon: coupon,
                        customer: customer,
                        buildContext: context,
                        merchant: getMerchantFromCoupon(coupon),
                        navigate: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerHomeView(
                                        user: customer,
                                      )));
                        },
                      )));
        },
        child: Container(
          color: Colors.white10,
          height: 110.0,
          padding: EdgeInsets.all(5.0),

//                        child: Card(
//                          shape: RoundedRectangleBorder(
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(8.0))),
          child: Card(
//                        color: Colors.,
            elevation: 15.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // add this
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(
                              coupon.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        flex: 3,
                      ),
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(2.0),
                              topRight: Radius.circular(2.0),
                              bottomLeft: Radius.circular(2.0),
                              bottomRight: Radius.circular(2.0)),
                          child: Container(
                            margin: EdgeInsets.only(left: 3),
                            height: 140,
//                                      color: Colors.lightBlue[200],
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      coupon.code,
                                      style: Style.couponHistoryTextStyle,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      coupon.description,
                                    ),
                                  ),
                                  flex: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  flex: 10,
                ),
              ],
            ),
          ),
//                    )
        ));

    Widget _getListUi(BuildContext context) {
      return ListView.builder(
          itemCount: coupons.length,
          itemBuilder: (context, itemIndex) {
            var couponItem = coupons[itemIndex];
            return makeCard(context, couponItem);
          });
    }

    return Stack(
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
                      // IconButton(
                      //   padding: EdgeInsets.only(top: 30),
                      //   icon: Icon(Icons.sort),
                      //   onPressed: null,
                      //   color: Colors.white,
                      //   iconSize: 28.0,
                      // ),
                      // Expanded(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Container(
                      //         margin: EdgeInsets.only(left: 20, top: 25),
                      //         child: Text(
                      //           'abc',
                      //           style: TextStyle(
                      //               fontSize: 25, color: Colors.white),
                      //         ),
                      //       ),
                      //       Container(
                      //         margin: EdgeInsets.only(left: 20),
                      //         child: Text(
                      //           'abc',
                      //           style: TextStyle(
                      //               fontSize: 15, color: Colors.white),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      //   flex: 2,
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        
        
        ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
                width: 250,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 20, left: 30.0, bottom: MediaQuery.of(context).size.height*0.57),
                child: Container(
                  height: 380,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:NetworkImage("https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395__340.jpg"),
                      fit: BoxFit.fill )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 15,
                        top: 5,
                        child: Text("Advertisement for lease",
                        style: TextStyle(
                                    fontSize: 15, color: Colors.greenAccent),
                              ),
                      ),
                      Positioned(
                        left: 15,
                        bottom: 5,
                        child:  FlatButton(
                                child: Text('Get Now',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black)),
                                onPressed: null,
                                disabledColor: Colors.white,
                              ),
                      ),
                    ],
                  ),
                )
                ),
            Container(
                width: 250,
                alignment: Alignment.topCenter,
                padding:
                    EdgeInsets.only(top: 20, left: 15, right: 15, bottom:MediaQuery.of(context).size.height*0.57),
                child: Container(
                  height: 380,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:NetworkImage("https://cdn.pixabay.com/photo/2016/02/19/10/00/food-1209007__340.jpg"),
                      fit: BoxFit.fill )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 15,
                        top: 5,
                        child: Text("Advertisement for lease",
                        style: TextStyle(
                                    fontSize: 15, color: Colors.greenAccent),
                              ),
                      ),
                      Positioned(
                        left: 15,
                        bottom: 5,
                        child:  FlatButton(
                                child: Text('Get Now',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black)),
                                onPressed: null,
                                disabledColor: Colors.white,
                              ),
                      ),
                    ],
                  ),
                )),
            Container(
                width: 250,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 20, right: 30, bottom: MediaQuery.of(context).size.height*0.57),
                child: Container(
                  height: 380,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:NetworkImage("https://www.foodiesfeed.com/wp-content/uploads/2019/07/blueberry-cheesecake-with-poppyseed-600x400.jpg"),
                      fit: BoxFit.fill )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 15,
                        top: 5,
                        child: Text("Advertisement for lease",
                        style: TextStyle(
                                    fontSize: 15, color: Colors.greenAccent),
                              ),
                      ),
                      Positioned(
                        left: 15,
                        bottom: 5,
                        child:  FlatButton(
                                child: Text('Get Now',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black)),
                                onPressed: null,
                                disabledColor: Colors.white,
                              ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.24),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 6,
                      child: Container(
                          padding: EdgeInsets.only(left: 35),
                          child: Text(
                            "Categories",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ))),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: FlatButton(
                        child: Text("View all >"),
                        onPressed: null,
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MerchantListView(
                                        customer: customer,
                                        category: "Food",
                                        navigate: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerHomeView(
                                                        user: customer,
                                                      )));
                                        },
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 100,
                          height: 70,
                          child: CircleAvatar(
                              backgroundImage:
                                  ExactAssetImage('assets/feast-box.jpg'),
                              minRadius: 90,
                              maxRadius: 150),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Food',
                            textAlign: TextAlign.center,
                          ))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MerchantListView(
                                        customer: customer,
                                        category: "Clothing",
                                        navigate: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerHomeView(
                                                        user: customer,
                                                      )));
                                        },
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          width: 100,
                          height: 70,
                          child: CircleAvatar(
                              backgroundImage:
                                  ExactAssetImage('assets/clothing.png'),
                              minRadius: 90,
                              maxRadius: 150),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Clothing',
                            textAlign: TextAlign.center,
                          ))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MerchantListView(
                                        customer: customer,
                                        category: "Accessories",
                                        navigate: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerHomeView(
                                                        user: customer,
                                                      )));
                                        },
                                      )));
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left: 20),
                          width: 100,
                          height: 70,
                          child: CircleAvatar(
                              backgroundImage:
                                  ExactAssetImage('assets/accessories.jpg'),
                              minRadius: 90,
                              maxRadius: 150),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Accessories',
                            textAlign: TextAlign.center,
                          ))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.44),
          child: Column(
            children: <Widget>[
              Divider(color: Colors.white,),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(left: 35,),
                        child: Text(
                          "Coupon List",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                    height: screenHeight(context, decreasedBy: 470),
                    padding: EdgeInsets.only(left: 28, right: 28),
                    child: _getListUi(context)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
