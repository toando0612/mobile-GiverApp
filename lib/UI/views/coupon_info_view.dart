import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/draw_horizontal_line.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/shared/ui_reducers.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:giver_app/UI/views/merchant_profile_view.dart';
import 'package:giver_app/UI/widgets/simple_toolbar.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/qr_scan_view_model.dart';

class CouponInfoView extends StatefulWidget {
  const CouponInfoView({@required this.customer, @required this.merchant, @required this.coupon, @required this.navigate, this.buildContext});
  final Function() navigate;
  final User customer;
  final User merchant;
  final Coupon coupon;
  final BuildContext buildContext;
  @override
  _CouponInfoViewState createState() => _CouponInfoViewState();
}

class _CouponInfoViewState extends State<CouponInfoView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<QrScanViewModel>(
      user: widget.customer,
      builder: (context, child, model) => Scaffold(
        backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading:  FlatButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () =>
                    Navigator.pop(widget.buildContext)
                 
                ),
                  ),
                  body: 
                  
                  Container(color: Colors.white,
                    
                  height: screenHeight(context, decreasedBy: toolbarHeight),
                  child: _getBodyUi(context, model)),
      )
      
    );
  }
  

  Widget _getBodyUi(BuildContext context, QrScanViewModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return _getLoadingUi(context);
      case ViewState.NoDataAvailable:
        return _noDataUi(context, model);
      case ViewState.Error:
        return _errorUi(context, model);
      case ViewState.DataFetched:
        return getCouponInfoWidget(context,model, widget.merchant, widget.coupon);
      default:
        return getCouponInfoWidget(context,model, widget.merchant, widget.coupon);
    }
  }
   Widget getCouponInfoWidget(BuildContext context,
      QrScanViewModel model, User merchant, Coupon coupon) {
    // return Container(
    //   child: CouponInfoItem(
    //       coupon: coupon,
    //       merchant: merchant,
    //       onRedeemed: () => showConfirmationDialog(model, coupon)
    //       ),
    // );
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          _getCouponInfoUi(context, model),
          _getCouponInfoHeader(merchant)
        ],
      ),
    );
  }
  Widget _getCouponInfoHeader(User merchant) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        alignment: FractionalOffset.topCenter,
        child: Hero(
          tag: "tag",
          child: merchant.imageUrl==null||merchant.imageUrl==''?Image.asset('assets/merchant.jpg', fit: BoxFit.fill,width: 92,height: 92,):Image.network(merchant.imageUrl,
              fit: BoxFit.fill,width: 92,height: 92)
        ));
  }


  Widget _getCouponInfoUi(BuildContext context, QrScanViewModel model){
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
                borderRadius: new BorderRadius.circular(30.0)),
            minWidth: 200,
            child: RaisedButton(
              child: Text(
                "Redeem Now",
                style: Style.infoTextStyle,
              ),
              onPressed: () => showConfirmationDialog(model, widget.coupon),
              color: Colors.white,
            ),
          ),
           Container(
            height: 20,
          ),
          Text(
            "Valid till 30/4",
            style: Style.commonTextStyle,
          )
        ],
      ),
    );
  }
  showConfirmationDialog(QrScanViewModel model, Coupon coupon) {
    String name = coupon.code;
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure to use this $name coupon'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    model.onCouponRedeemed(coupon.id, widget.customer.id);
                    Navigator.pop(context);
                    Navigator.pop(widget.buildContext);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MerchantProfileView(
                    //               customer: widget.customer, merchant: widget.merchant,
                    //             )));
                  },
                  child: Text('Ok')),
              FlatButton(
                onPressed: () {                 
                 Navigator.pop(context);
                
                },
                child: Text('Cancel'),
              )
            ],
          );
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

  Widget _noDataUi(BuildContext context, QrScanViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, QrScanViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, QrScanViewModel model,
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