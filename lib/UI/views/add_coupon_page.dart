import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/model/user.dart';

class AddCoupon extends StatefulWidget {
  AddCoupon({
    @required this.user,
  });
  final User user;
  @override
  _AddCouponsState createState() => _AddCouponsState();
}

class _AddCouponsState extends State<AddCoupon> {
  String selectedImageUrl = '';
  final _pointController = TextEditingController();
  String description;
  int points;
  String code;
//  String imageUrl;
  int selectRadio;
//  bool isUse;

  String imageUrl1 =
      'https://cdn.vox-cdn.com/thumbor/0wUQFReNjJBMitnKho_1y-EMl9M=/0x0:5520x3680/1200x0/filters:focal(0x0:5520x3680):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/10542175/by_CHLOE._2__1_.jpg';
  String imageUrl2 =
      'https://img2.pngdownload.id/20180521/zxt/kisspng-fashion-illustration-shopping-clothing-5b027baa6f52a7.032421651526889386456.jpg';
  String imageUrl3 =
      'https://theadventurine.com/wp-content/uploads/2016/05/adv_key_profile_hs_830X430.jpg';
//  @override
//  void innitState() {
//    super.initState();
//    selectRadio = 0;
//  }

  setSelectedRadio(int val) {
    setState(() {
      selectRadio = val;

    });
  }

  void _addData(User user) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference addDataCoupon =
          await Firestore.instance.collection("coupons").add({
//        "user": widget.user,
        "description": description,
        "points": int.parse(_pointController.text),
        "ownedBy": user.id,
        "code": code,
        "isUsed": false,
        "isPending": false,
        "usedBy": "",
        "imageUrl": selectedImageUrl,
        "time" : DateTime.now(),
      });
//      print(addDataCoupon.documentID.toString());
      CollectionReference addUidMerchant = Firestore.instance
          .collection("users")
          .document(user.id)
          .collection("ownedCoupons");
      await addUidMerchant.document(addDataCoupon.documentID).setData({
        "merchantId":
            Firestore.instance.collection("users").document(user.id).documentID
      });
    });
    _navigateToMerchantHomeView();
  }

  _navigateToMerchantHomeView() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MerchantHomeView(
                  user: widget.user,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _navigateToMerchantHomeView),
        title: Center(
          child: Text('Add Coupon'),
        ),
      ),
      body: Material(
          child: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (String str) {
                    setState(() {
                      code = str;
                    });
                  },
                  decoration: new InputDecoration(
                      icon: Icon(Icons.title), hintText: "Coupon Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (String str) {
                    setState(() {
                      description = str;
                    });
                  },
                  decoration: new InputDecoration(
                      icon: Icon(Icons.dashboard),
                      hintText: "Coupon Description"),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _pointController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.control_point),
                    hintText: "Enter points number",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),

              Row(
                children: <Widget>[
                  Expanded(flex: 3,
                                      child: Column(
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: selectRadio,
                          onChanged: (val) {
                            setState(() {
                              selectedImageUrl = imageUrl1;
                            });
                            setSelectedRadio(val);
                          },
                        ),
                        Container(
                          width: 125,
                          height: 125,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(imageUrl1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                                      child: Column(
                      children: <Widget>[
                        Radio(
                          value: 2,
                          groupValue: selectRadio,
                          onChanged: (val) {
                            setState(() {
                              selectedImageUrl = imageUrl2;
                            });
                            setSelectedRadio(val);
                          },
                        ),
                        Container(
                          width: 125,
                          height: 125,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(imageUrl2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                                      child: Column(
                      children: <Widget>[
                        Radio(
                          value: 3,
                          groupValue: selectRadio,
                          onChanged: (val) {
                            setState(() {
                              selectedImageUrl = imageUrl3;
                            });
                            setSelectedRadio(val);
                          },
                        ),
                        Container(
                          width: 125,
                          height: 125,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(imageUrl3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      _addData(widget.user);
                    },
                    child: Text('Add'),
                  ),
                  RaisedButton(
                    onPressed: _navigateToMerchantHomeView,
                    child: Text('Cancel'),
                  )
                ],
              )

//          new Padding(
//              padding: const EdgeInsets.all(16.0),
//            child: ,
//          )
            ],
          ),
        ),
      )),
    );
  }
}
