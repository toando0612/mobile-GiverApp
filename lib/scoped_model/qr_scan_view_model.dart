
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/scoped_model/base_model.dart';

import '../service_locator.dart';

class QrScanViewModel extends BaseModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  List<Coupon> coupons;
  List<User> merchants;

  QrScanViewModel() {
    _firebaseService.coupons.asBroadcastStream().listen(_onCouponUpdated);   
    _firebaseService.merchants.asBroadcastStream().listen(_onUsersUpdated); 
  }


  void onCouponRedeemed(String couponID, String customerID){
    _firebaseService.moveCouponToPending(couponID, customerID);
  }

  Future<User> getMerchantFromCoupon(Coupon coupon) async {
    for (User user in merchants){
      if(coupon.ownedBy == user.id){
        return user;
      }
    }
    return null;
  }
  
  Future<Coupon> getCouponFromBarcode(String barcode) async{
    for (Coupon coupon in coupons) {
      if (coupon.id == barcode){
        return coupon;
      }
    }
    return null;
  }

  Future<bool> onDataReceived(List<Coupon> currentCoupons, String scannedData) async {
    Coupon scannedCoupon;
    for(Coupon c in currentCoupons){
      if (c.id == scannedData){
        scannedCoupon = c;
        if (scannedCoupon.isPending || scannedCoupon.isUsed){
          return false;
        }
        else {
          return true;
        }
      }
    }
    return false;

  }
  void _onUsersUpdated(List<User> user) {
    merchants = user;
    if (merchants == null) {
      setState(ViewState.Busy);
    } else {
      setState(merchants.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.WaitingForInput);
    }
  }

  void _onCouponUpdated(List<Coupon> coupon) {
    coupons = coupon;    
    if (coupons == null) {
      setState(ViewState.Busy);   
    } else {
      setState(coupons.length == 0 
          ? ViewState.NoDataAvailable
          : ViewState.WaitingForInput);
    }
  }

  






}
