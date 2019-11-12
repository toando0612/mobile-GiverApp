import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:image_picker/image_picker.dart';

class EditCoupon extends StatefulWidget {
  EditCoupon({
    @required this.user,
    @required this.coupon,
  });
  final User user;
  final Coupon coupon;
  // final usedBy;
  // final index;
  @override
  _EditCouponState createState() => _EditCouponState();
}

class _EditCouponState extends State<EditCoupon> {
  Flushbar flush;
  var isEditProfileImage = false;

//save the result of camera file
  File uploadFile;
  String description;
  int points;
  bool isUsed = false;
  String ownedBy;
  String code;
//  String usedBy;

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  void onChanged(bool value) {
    setState(() {
      isUsed = value;
    });
  }

  Future<bool> updateNewImage(StorageReference ref, BuildContext context) async {
    print('start add new image');
    print('firename:');
    print(widget.coupon.code);
    StorageUploadTask uploadTask = ref.putFile(uploadFile);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    setState(() {
      isEditProfileImage = false;
      flush = Flushbar<bool>(
          flushbarPosition: FlushbarPosition.BOTTOM,
          title: "Congratulations!",
          message: "Profile image successfully updated!",
          duration: Duration(seconds: 4),
        )..show(context);
    });
    _editImage(url, context);
    return true;
  }

  Future uploadPic(
      BuildContext context) async {
    print('deleting old image && add new image process:');
    // reference to image file of current user
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profileImages/' + widget.coupon.code);
    updateNewImage(firebaseStorageRef, context);
  }

  imageSelectorGallery() async {
    uploadFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );
    print("You selected gallery image : " + uploadFile.path);
    setState(() {
      isEditProfileImage = true;
    });
  }

  imageSelectorCamera() async {
    uploadFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );
    print("You took camera image : " + uploadFile.path);
    setState(() {
      isEditProfileImage = true;
    });
  }

  _editImage(String url, BuildContext context) {
      Firestore.instance
          .collection("coupons")
          .document(widget.coupon.id)
          .updateData({
        'imageUrl': url,
      });
  }

  _editCoupon() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      Firestore.instance
          .collection("coupons")
          .document(widget.coupon.id)
          .updateData({
        'description': description,
        'points': points,
        'isUsed': isUsed,
        'code': code,
      }).then(_navigateToMerchantHomeView());
    }
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
          child: Text('Edit Coupon'),
        ),
      ),
      body: SingleChildScrollView(
        child: Material(
            child: Form(
              key: _key,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
                  //
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: Icon(Icons.camera_alt),
                                onPressed: () => imageSelectorCamera(),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              FlatButton(
                                child: Icon(Icons.photo_library),
                                onPressed: () => imageSelectorGallery(),
                              )
                            ],
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          flex: 6,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.deepPurpleAccent ,
                                child: ClipOval(
                                  child: new SizedBox(
                                      width: 190.0,
                                      height: 190.0,
                                      child: uploadFile != null
                                          ? Image.file(
                                        uploadFile,
                                        fit: BoxFit.fill,
                                      )
                                          : widget.coupon.imageUrl==null||widget.coupon.imageUrl==''
                                          ? Image.asset('assets/coupon.jpg')
                                          : Image.network(widget.coupon.imageUrl)
                                  ),
                                ),
                              ),
                              onTap: () => imageSelectorGallery(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: !isEditProfileImage
                              ? Text('')
                              : Column(
                            children: <Widget>[
                              FlatButton(
                                child: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    uploadFile = null;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              FlatButton(
                                child: Icon(Icons.check_box),
                                onPressed: () => uploadPic(context),
                              )
                            ],
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: widget.coupon.code,
                      onSaved: (input) => code = input,
                      decoration: new InputDecoration(
                          icon: Icon(Icons.title),
                          hintText: "Coupon Name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: widget.coupon.description,
                      onSaved: (input) => description = input,
                      decoration: new InputDecoration(
                          icon: Icon(Icons.dashboard),
                          hintText: "Coupon Description"),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: widget.coupon.points.toString(),
                      onSaved: (input) => points = int.parse(input),
                      decoration: InputDecoration(
                        icon: Icon(Icons.control_point),
//                 hintText: "${widget.user.points}",
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _editCoupon,
                        child: Text('Update'),
                      ),
                      RaisedButton(
                        onPressed: _navigateToMerchantHomeView,
                        child: Text('Cancel'),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}