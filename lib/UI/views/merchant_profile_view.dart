import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/shared/ui_reducers.dart';
import 'package:giver_app/UI/views/coupon_info_view.dart';
import 'package:giver_app/UI/views/customer_home_view.dart';
import 'package:giver_app/UI/widgets/merchant_image.dart';
import 'package:giver_app/UI/widgets/merchant_info.dart';
import 'package:giver_app/UI/widgets/simple_toolbar.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:giver_app/enum/view_state.dart';

class MerchantProfileView extends StatelessWidget {
  const MerchantProfileView({@required this.merchant, @required this.customer});
  final User customer;
  final User merchant;

  @override
  Widget build(BuildContext context) {
    double appBarHeight = 50;
    return BaseView<MerchantProfileViewModel>(
        user: customer,
        builder: (context, child, model) =>
            Stack(overflow: Overflow.clip, children: <Widget>[
              MerchantImage(
                merchant: merchant,
              ),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                     preferredSize: Size.fromHeight(appBarHeight),
                                      child: AppBar(
                      
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.black,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
                  body: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50.0,
                          color: Colors.white,
                          child: MerchantInfo(
                            merchant: merchant,
                            customer: customer,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                            color: Colors.white,
                            height: screenHeight(context,
                                decreasedBy: 194 + appBarHeight),
                            child: _getBodyUi(context, model)),
                      ),
                    ],
                  ))
            ]));
  }

  Widget _getBodyUi(BuildContext context, MerchantProfileViewModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return _getLoadingUi(context);
      case ViewState.NoDataAvailable:
        return _noDataUi(context, model);
      case ViewState.Error:
        return _errorUi(context, model);
      case ViewState.DataFetched:
        return _getListUi(context, model);
      default:
        return _getListUi(context, model);
    }
  }

  ListTile makeListTile(BuildContext context, MerchantProfileViewModel model,
          Coupon coupon) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.shopping_basket, color: Colors.white),
        ),
        title: Text(
          coupon.code,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(coupon.description,
                      style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        trailing: FlatButton(
          child: Text(
            'Use Coupon',
            style: Style.commonTextStyle,
          ),
          onPressed: () {
            model.redeemCoupon(coupon.id, customer.id);
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Alert'),
                    content: Text(
                        'Your coupon usage will be reviewed by our merchant'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text("Dismiss"),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  );
                });
          },
        ),
      );

  Widget makeCard(BuildContext context, MerchantProfileViewModel model,
          Coupon coupon) =>
      GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CouponInfoView(
                          coupon: coupon,
                          customer: customer,
                          merchant: merchant,
                          buildContext: context,
                          navigate: () {
                                
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MerchantProfileView(
                                  customer: customer, merchant: merchant,
                                )));
                          },
                        )));
          },
          child: Container(
            color: Colors.white10,
            height: 140.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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

  Widget _getListUi(BuildContext context, MerchantProfileViewModel model) {
    List<Coupon> coupons = model.getCouponsByMerchantID(merchant.id);
    return ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, itemIndex) {
          var couponItem = coupons[itemIndex];

          return makeCard(context, model, couponItem);
        });
  }

  Widget _getLoadingUi(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        Text('Fetching data ...')
      ],
    ));
  }

  Widget _noDataUi(BuildContext context, MerchantProfileViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, MerchantProfileViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, MerchantProfileViewModel model,
      {bool error = false}) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                error
                    ? Icon(
                        // WWrap in gesture detector and call you refresh future here
                        Icons.refresh,
                        color: Colors.white,
                        size: 45.0,
                      )
                    : Container()
              ],
            )));
  }
}
