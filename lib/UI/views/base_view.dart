import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/model/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../service_locator.dart';

class BaseView<T extends Model> extends StatefulWidget {
  final ScopedModelDescendantBuilder<T> _builder;
  final Function(T) onModelReady;
  final User user;

  /// Function will be called as soon as the widget is initialised.
  ///
  /// Callback will reive the model that was created and supplied to the ScopedModel

  BaseView({ScopedModelDescendantBuilder<T> builder, this.onModelReady, this.user})
      : _builder = builder;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends Model> extends State<BaseView<T>> {
  T _model = locator<T>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  Flushbar flush;
  bool _wasButtonClicked;
  
  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }
    super.initState();
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage : $message");
      
        if (message['data']['tag'] == 'approval' && widget.user.level == 2) {
          flush = Flushbar<bool>(
            flushbarPosition: FlushbarPosition.BOTTOM,
            title: message['notification']['title'],
            message: message['notification']['body'],
            duration: Duration(seconds: 4),
            mainButton: FlatButton(
              child: Text('Approve', style: TextStyle(color: Colors.amber)),
              onPressed: () {
                flush.dismiss(true);
                _redeem(message['data']['cId']);
                
              },
            ),
          )..show(context).then((result) {
              setState(() {
                _wasButtonClicked = true;
              });
            });
        }
        if (message['data']['tag'] == 'updateNotify' && widget.user.level == 1) {
          flush = Flushbar(
            title: message['notification']['title'],
            message: message['notification']['body'],
            duration: Duration(seconds: 5),
            mainButton: FlatButton(
              child: Text('Dismiss', style: TextStyle(color: Colors.amber)),
              onPressed: () {
                flush.dismiss(true);
              },
            ),
          )..show(context);
        }
        if (message['data']['tag'] == 'newCoupon' && widget.user.level == 1) {
          flush = Flushbar(
            title: message['notification']['title'],
            message: message['notification']['body'],
            duration: Duration(seconds: 5),
            mainButton: FlatButton(
              child: Text('Dismiss', style: TextStyle(color: Colors.amber)),
              onPressed: () {
                flush.dismiss(true);
              },
            ),
          )..show(context);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch : $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume : $message");
      },
    );
  }

  

  _redeem(String id) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'approveCoupon');
    dynamic isSuccess = await callable.call(<String, dynamic> {'couponID' : id});
    
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<T>(
        model: _model,
        child: ScopedModelDescendant<T>(
            child: Container(color: Colors.red), builder: widget._builder));
  }

  _saveDeviceToken() async {
    // Get the current user
    
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null && widget.user != null) {
      var tokens = Firestore.instance
          .collection('users')
          .document(widget.user.id)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), 
        'platform': Platform.operatingSystem 
      });
    }
  }
}


