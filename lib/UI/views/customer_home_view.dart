import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/views/coupon_info_view.dart';
import 'package:giver_app/UI/views/qr_scan_view.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/UI/widgets/charity_list.dart';
import 'package:giver_app/UI/widgets/customer_drawer.dart';
import 'package:giver_app/UI/widgets/customer_home_widget.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/widgets/merchant_item.dart';
import 'package:giver_app/UI/widgets/merchant_list.dart';
import 'package:giver_app/blocs/firebase_bloc.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'base_view.dart';
import 'customer_history_view.dart';

enum WidgetMarker { home, charityOrganizations, history }

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({@required this.user});
  final User user;
  @override
  _CustomerHomeViewState createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  WidgetMarker selectedWidget = WidgetMarker.home;
  String _selectedTittle = 'Home';
  int _selectedIndex = 0;
 final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedIndex == 0
          ? selectedWidget = WidgetMarker.home
          : _selectedIndex == 1
              ? selectedWidget = WidgetMarker.charityOrganizations
              : selectedWidget = WidgetMarker.history;
      _selectedIndex == 0
          ? _selectedTittle = 'Home'
          : _selectedIndex == 1
              ? _selectedTittle = 'Charity'
              :_selectedTittle = 'History' ;
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllCoupons();
    bloc.fetchAllMerchants();
    return MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
                  key: scaffoldKey,
                  appBar: _getAppBar(_selectedTittle, widget.user.points),
                  drawer: CustomerDrawer(customer: widget.user),
                  body: _getBodyUi(context),
                  bottomNavigationBar: _getBottomBar(),
                ),
          ),
        );
  }

  Widget _getAppBar(String title, int points) {
    
      return AppBar(
        backgroundColor: Color(0xFF9C27B0),
      title: Center(child: Text(title)),
      actions: <Widget>[
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Credit ',
                  style: TextStyle(fontSize: 10),
                  children: <TextSpan>[
                    TextSpan(text: points.toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
            ),
        FlatButton(
          onPressed: ()=> Navigator.pushReplacement(
              context, MaterialPageRoute(
                builder: (context) => QrScanView(customer: widget.user,))),
          child: Icon(Icons.camera_alt),
        )
      ],bottom: selectedWidget == WidgetMarker.history?TabBar(
      tabs: [
        Tab(icon: FlatButton.icon(onPressed: null, icon: Icon(Icons.web), label: Text('Coupons'))),
        Tab(icon: FlatButton.icon(onPressed: null, icon: Icon(Icons.favorite), label: Text('Donate')))
      ],
    ): null,
      
    );
    
  
  }

  Widget _getBottomBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home', ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          title: Text('Charity'),
        ),
     
        
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          title: Text('History'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.deepPurpleAccent,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }

  

  Widget getMerchantList(String category, UserHomeViewModel model){
    return Column(
      children: <Widget>[
        
        Expanded(
          child: ListView.builder(
              itemCount: model.getCategorizedMechants(model.merchants, category).length,
              itemBuilder: (context, rowNumber) {
                var merchants = model.getCategorizedMechants(model.merchants, category);
                var merchant = merchants[rowNumber];
                print('merchant item:');
                return MerchantItem(
                    merchant: merchant, customer: widget.user);
              }),
          flex: 9,
        ),
      ],
    );
  }

//switch body widget function
  Widget _getBodyUi(BuildContext context) {
//    switch (model.state) {
//      case ViewState.NoDataAvailable:
//        return _noDataUi(context, model);
//      case ViewState.Error:
//        return _errorUi(context, model);
//      case ViewState.DataFetched:
//        return selectedWidget == WidgetMarker.home
//            ? CustomerHomeWidget(customer: widget.user, coupons: model.getUnusedCoupons(), merchants: model.merchants,
//
//             ):
//            selectedWidget == WidgetMarker.charityOrganizations
//            ? CharityList(model: model,customer: widget.user,):
//            CustomerHistoryView(user: widget.user,);
//
//      default:
//        return CustomerHomeWidget( customer: widget.user, coupons: model.coupons, merchants: model.merchants, );
//    }
  return CustomerHomeWidget(customer: widget.user, coupons: bloc.allCoupons, merchants: bloc.allMerchants,
//
             );
  }


//  Widget _noDataUi(BuildContext context, UserHomeViewModel model) {
//    return _getCenteredViewMessage(context, "No data available yet", model);
//  }
//
//  Widget _errorUi(BuildContext context, UserHomeViewModel model) {
//    return _getCenteredViewMessage(
//        context, "Error retrieving your data. Tap to try again", model,
//        error: true);
//  }
//
//  Widget _getCenteredViewMessage(
//      BuildContext context, String message, UserHomeViewModel model,
//      {bool error = false}) {
//    return Center(
//        child: Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 20.0),
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Text(
//                  message,
//                  style: TextStyle(
//                      fontSize: 20.0,
//                      fontWeight: FontWeight.w800,
//                      color: Colors.grey),
//                  textAlign: TextAlign.center,
//                ),
//                error
//                    ? Icon(
//                        // WWrap in gesture detector and call you refresh future here
//                        Icons.refresh,
//                        color: Colors.white,
//                        size: 45.0,
//                      )
//                    : Container()
//              ],
//            )));
//  }

}