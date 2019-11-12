import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/draw_horizontal_line.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/shared/ui_reducers.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:giver_app/UI/views/merchant_profile_view.dart';
import 'package:giver_app/UI/widgets/merchant_item.dart';
import 'package:giver_app/UI/widgets/merchant_list.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/qr_scan_view_model.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';

class MerchantListView extends StatefulWidget {
  const MerchantListView({@required this.customer, @required this.navigate, @required this.category});
  final Function() navigate;
  final User customer;
  final String category;
  
  @override
  _MerchantListViewState createState() => _MerchantListViewState();
}

class _MerchantListViewState extends State<MerchantListView> {
  List<User> categorizedMerchant;
  
  @override
  Widget build(BuildContext context) {
    return BaseView<UserHomeViewModel>(
      user: widget.customer,
      builder: (context, child, model) => Scaffold(
        backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.deepPurpleAccent,
                    leading:  FlatButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    widget.navigate();
                    
                  },
                ),
                  ),
                  body: 
                  
                  Container(color: Colors.white,
                    
                  height: screenHeight(context, decreasedBy: 0),
                  child: _getBodyUi(context, model)),
      )
      
    );
  }
  

  Widget _getBodyUi(BuildContext context, UserHomeViewModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return _getLoadingUi(context);
      case ViewState.NoDataAvailable:
        return _noDataUi(context, model);
      case ViewState.Error:
        return _errorUi(context, model);
      case ViewState.DataFetched:
        return _getMerchantListUi(context,model);
      default:
        return _getMerchantListUi(context,model);
    }
  }


  Widget _getMerchantListUi(BuildContext context, UserHomeViewModel model){
    categorizedMerchant = model.getCategorizedMechants(model.merchants, widget.category);
    return Column(
      children: <Widget>[     
        Expanded(
          child: ListView.builder(
              itemCount: categorizedMerchant.length,
              itemBuilder: (context, rowNumber) {
                var merchants = categorizedMerchant;
                var merchant = merchants[rowNumber];
                print('merchant item:');
                return MerchantItem(
                    merchant: merchant, customer: widget.customer);
              }),
          flex: 9,
        ),
      ],
    );
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

  Widget _noDataUi(BuildContext context, UserHomeViewModel model) {
    return _getCenteredViewMessage(context, "No data available yet", model);
  }

  Widget _errorUi(BuildContext context, UserHomeViewModel model) {
    return _getCenteredViewMessage(
        context, "Error retrieving your data. Tap to try again", model,
        error: true);
  }

  Widget _getCenteredViewMessage(
      BuildContext context, String message, UserHomeViewModel model,
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