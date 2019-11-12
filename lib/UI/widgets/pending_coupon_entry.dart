import 'package:cloud_functions/cloud_functions.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/scoped_model/pending_coupon_entry_view_model.dart';

class PendingCouponEntry extends StatefulWidget {
  const PendingCouponEntry({@required this.merchant});


  final User merchant;

  @override
  _PendingCouponEntryState createState() => _PendingCouponEntryState();
}

class _PendingCouponEntryState extends State<PendingCouponEntry> {
  Widget pendingEntry(BuildContext context, PendingCouponEntryViewModel model, Coupon coupon) {
    var time = coupon.time.toDate();
    var date = formatDate(time, [dd, "/", mm]);
    var hour = formatDate(time, [hh, ":", nn, " ", am]);
    String usedBy = model.getUsedBy(coupon.usedBy);
    return Container(
      height: 70,
      width: double.infinity,
      child: Card(
          elevation: 10,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[Text(date), Text(hour)],
                  ))),
              Expanded(
                flex: 4,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      coupon.code,
                      style: Style.couponHistoryTextStyleBigger,
                    ),
                    Text(
                      usedBy,
                      style: Style.couponHistoryTextStyle,
                    ),
                  ],
                )),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: IconButton(
                          icon: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          onPressed: () => model.redeemCoupon(coupon.usedBy, coupon.id, coupon.points),
                        ),
                      ),
                      Container(
                        width: 30,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () => model.denyCoupon(coupon.id),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BaseView<PendingCouponEntryViewModel>(
        builder: (context, child, model) => Scaffold(
            backgroundColor: Colors.deepPurpleAccent,
            appBar: AppBar(
              title: Text("Pending Coupons"),
              elevation: 0,
              backgroundColor: Colors.deepPurpleAccent,
              leading: FlatButton(
                  onPressed: () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                          => MerchantHomeView(user: widget.merchant,)))},
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            body: _getBodyUi(context, model)));
  }

  Widget _getBodyUi(BuildContext context, PendingCouponEntryViewModel model) {
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

   Widget _getListUi(BuildContext context, PendingCouponEntryViewModel model) {
    
    return ListView.builder(
        itemCount: model.getPendingEntry(widget.merchant.id).length,
        itemBuilder: (context, itemIndex) {
          var couponItem = model.getPendingEntry(widget.merchant.id)[itemIndex];
          
          return pendingEntry(context, model, couponItem);
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

  Widget _noDataUi(BuildContext context, PendingCouponEntryViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, PendingCouponEntryViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, PendingCouponEntryViewModel model,
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
