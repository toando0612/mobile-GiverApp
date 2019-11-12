
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/enum/view_state.dart';
export 'package:giver_app/enum/view_state.dart';


import '../service_locator.dart';

class MerchantProfileViewModel extends BaseModel {

  FirebaseService _firebaseService = locator<FirebaseService>();
  List<Coupon> coupons;
 
  MerchantProfileViewModel() {
    _firebaseService.coupons.asBroadcastStream().listen(_onCouponUpdated);  
  }

  void redeemCoupon(String couponID, String customerID){
    _firebaseService.moveCouponToPending(couponID, customerID);
  }
  
  List<Coupon> getCouponsByMerchantID(String merchantID) {
    var result = List<Coupon>();
    for (Coupon coupon in coupons){
      if (coupon.ownedBy == merchantID) {
        if (coupon.usedBy.isEmpty) {
          result.add(coupon);
        }
      }
    }

    return result;
  }
  

  void _onCouponUpdated(List<Coupon> coupon) {

    coupons = coupon;
    
    if (coupons == null) {
      setState(ViewState.Busy);   
    } else {
      setState(coupons.length == 0 
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }

 

}