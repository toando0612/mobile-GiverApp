import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/UI/Views/sign_in_page.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/UI/views/top_screen_design.dart';
import 'package:giver_app/UI/widgets/merchant_history_entry.dart';
import 'package:giver_app/UI/widgets/pending_coupon_entry.dart';
import 'package:giver_app/UI/widgets/qr_image.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'package:giver_app/UI/views/base_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'add_coupon_page.dart';
import 'edit_coupon_page.dart';
import 'merchant_edit_info_view.dart';

class MerchantHomeView extends StatefulWidget {
  const MerchantHomeView({@required this.user});

  final User user;

  @override
  _MerchantHomeViewState createState() => _MerchantHomeViewState();
}

class _MerchantHomeViewState extends State<MerchantHomeView> {
  TextEditingController editingController = TextEditingController();
  int _selectedIndex = 0;
  PageController _pageController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  
    _pageController = new PageController();
  }
   

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void navigationTapped(int index) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  addCoupons() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => AddCoupon(user: widget.user)));
  }

  Widget customBodyWidget(UserHomeViewModel model) {
    switch (_selectedIndex) {
      case 0:
        return getHomeView(model);
      case 1:
        return getHistoryView(model);
    }
  }
  showConfirmationDialog(Coupon coupon,User merchant) {
    String name = coupon.code;
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure to delete this $name coupon'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    _deleteCoupon(coupon, merchant);
                    Navigator.pop(context);
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

  Widget getHomeView(UserHomeViewModel model) {
    List<Coupon> couponList =
        model.getCouponsByMerchantId(model.coupons, widget.user.id);
    List<Coupon> usedCoupons = List<Coupon>();
    for (Coupon coupon in couponList) {
      if (!coupon.isUsed) {
        usedCoupons.add(coupon);
      }
    }
    return Stack(
      children:<Widget>[
        Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.only(left: 20,top: 10),
            width: MediaQuery.of(context).size.width,
//            color: Color(0xFFC6FF00),
            child: Text('Coupon List', style: Style.couponHistoryTextStyleBigger,),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: usedCoupons.length,
                itemBuilder: (context, rowNumber) {
                  var coupon = usedCoupons[rowNumber];
                  String description = coupon.description.toString();
                  String name = coupon.code.toString();
                  String imageUrl = coupon.imageUrl.toString();

                  return Container(
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
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch, // add this
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
                                          child: Image.network(coupon.imageUrl,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  padding:EdgeInsets.only(top: 5) ,
                                                  child: Text(
                                                    name,style: Style.couponHistoryTextStyle,
                                                  ),
                                                ),
                                                flex: 1,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Text(description,),
                                                ),
                                                flex: 3,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator
                                                              .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              EditCoupon(
                                                                                user: widget.user,
                                                                                coupon: coupon,
                                                                              )));
                                                        },
                                                        icon: Icon(Icons.edit,size: 20,),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.wallpaper,size:20),
                                                        onPressed: () { Navigator
                                                              .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              QrWidget(coupon: coupon,
                                                                                
                                                                                
                                                                              )));},
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          showConfirmationDialog(coupon, widget.user);
                                                        },
                                                        icon: Icon(Icons.delete,size: 20,),
                                                      )
                                                    ]),
                                              )
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
                      );
                }),
            flex: 9,
          )
        ],
      ),
  ],
    );
  }

  _deleteCoupon(Coupon coupon, User user) {
    Firestore.instance.collection('coupons').document(coupon.id).delete();

//    Firestore.instance.collection('user').document(widget.user.id).collection('ownedCoupons').document(coupon.id).delete();
  }

  Widget getHistoryView(UserHomeViewModel model) {
    List<Coupon> usedCoupons = model.getUsedCouponsByMerchantId(widget.user.id);
    return ListView.builder(
        itemCount: usedCoupons.length,
        itemBuilder: (context, itemIndex) {
          var couponItem = usedCoupons[itemIndex];
          String usedBy = model.getUsedBy(couponItem.usedBy);
          return MerchantHistoryEntry(coupon: couponItem, usedBy: usedBy);
        });
    
    
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<UserHomeViewModel>(
        user: widget.user,
        builder: (context, child, model) => Scaffold(
          
          key: scaffoldKey,
          appBar: TopScreenDesign(user: widget.user,scaffoldKey: scaffoldKey,),
              drawer:  Drawer(
                child:  ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(widget.user.username, style: TextStyle( color: Colors.yellowAccent, fontWeight: FontWeight.bold)),
                      accountEmail: Text(widget.user.email, style: TextStyle( color: Colors.yellowAccent, fontWeight: FontWeight.bold, fontSize: 12, fontStyle: FontStyle.italic),),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: widget.user.imageUrl==null||widget.user.imageUrl=='' ? ExactAssetImage('assets/merchant.jpg'):NetworkImage(widget.user.imageUrl))),
                    ),
                    ListTile(
                        title: Text("Edit"),
                        trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MerchantEditInfoView(
                                          user: widget.user,
                                        ))))),
                    ListTile(
                      title: Text("Pending Coupons"),
                      trailing: IconButton(
                          icon: Icon(Icons.arrow_left), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)
                          => PendingCouponEntry(merchant: widget.user,)));})
                    ),
                    ListTile(
                      title: Text("Sign Out"),
                      trailing: IconButton(
                          tooltip: "Log out",
                          icon: Icon(Icons.exit_to_app),
                          onPressed: signOut),
                    ),
                  ],
                ),
              ),
              body: customBodyWidget(model),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('Home'),
                  ),
//                  BottomNavigationBarItem(
//                    icon: Icon(Icons.camera),
//                    title: Text('Camera'),
//                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    title: Text('History'),
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
            ));
  }
}