import 'package:giver_app/model/user.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/enum/view_state.dart';
export 'package:giver_app/enum/view_state.dart';

import '../service_locator.dart';

class PendingCouponEntryViewModel extends BaseModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  List<Coupon> coupons;
  List<User> customers;

  PendingCouponEntryViewModel() {
    _firebaseService.coupons.asBroadcastStream().listen(_onCouponUpdated);
    _firebaseService.customers.asBroadcastStream().listen(_onCustomerUpdated);
  }

  void redeemCoupon(String customerID, String couponID, int credit) {
    _firebaseService.redeemCoupon(couponID: couponID);
    _firebaseService.awardCredit(credit: credit, customerId: customerID);
  }
  

  void denyCoupon(String couponID){
    _firebaseService.denyCoupon(couponID: couponID);
  }

  List<Coupon> getPendingEntry(String merchantId){
     var result = List<Coupon>();
    for (Coupon coupon in coupons) {
      if (coupon.ownedBy == merchantId && coupon.isPending == true) {       
          result.add(coupon);       
      }
    }
    return result;
  }

  List<Coupon> getCouponsByMerchantID(String merchantID) {
    var result = List<Coupon>();
    for (Coupon coupon in coupons) {
      if (coupon.ownedBy == merchantID || coupon.isPending == true) {
        if (coupon.usedBy.isEmpty) {
          result.add(coupon);
        }
      }
    }

    return result;
  }

  String getUsedBy(String id) {
    for (User user in customers) {
      if (user.id == id) {
        return user.email;
      }
    }

    return "N/A";
  }

  void _onCustomerUpdated(List<User> customer) {
    setState(ViewState.Busy);
    customers = customer;
    if (customers == null) {
      setState(ViewState.Busy);
    } else {
      setState(customers.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
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
