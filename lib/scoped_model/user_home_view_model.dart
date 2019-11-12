import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/base_model.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/enum/view_state.dart';
export 'package:giver_app/enum/view_state.dart';


import '../service_locator.dart';

class UserHomeViewModel extends BaseModel {

  FirebaseService _firebaseService = locator<FirebaseService>();

  List<Coupon> coupons;
  List<User> merchants;
  List<User> customers;
  List<Charity> charities;



  UserHomeViewModel() {
    _firebaseService.customers.asBroadcastStream().listen(_onCustomerUpdated);
    _firebaseService.merchants.asBroadcastStream().listen(_onMerchantUpdated);
    _firebaseService.charities.asBroadcastStream().listen(_onCharityUpdated);
    _firebaseService.coupons.asBroadcastStream().listen(_onCouponUpdated);

  }

  User getCurrentUser(List<User> merchants,String id){
    this.setState(ViewState.Busy);
    User currentUser;
    for (User user in merchants){
        if (user.id == id ){
          currentUser = user;
        }
      }
    this.setState(ViewState.DataFetched);
    return currentUser;
  }

  List<User> getCategorizedMechants (List<User> users, String category){
    var result = List<User>();
    for (User merchant in users){
      if (merchant.category == category){
        result.add(merchant);
      }
    }
    return result;
  }
   
  
  

  Charity getCharityById(List<Charity> charities,String id){
    this.setState(ViewState.Busy);
    Charity currentCharity;
    for (Charity charity in charities){
      if (charity.id == id ){
        currentCharity = charity;
      }
    }
    this.setState(ViewState.DataFetched);
    return currentCharity;
  }

  Future<bool> onDonate(String charityId, String uId, int credits, int userPoints)async{
    setState(ViewState.Busy);
    bool result = await _firebaseService.donate(charityId: charityId, uid: uId, donatePoints: credits, userPoints: userPoints);
    setState(ViewState.DataFetched);
    return result;
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

  Future<bool> _onMerchantUpdated(List<User> merchant) async{
    setState(ViewState.Busy);
    await Future.delayed(Duration(seconds: 5));
    merchants = merchant;
    if (merchants == null) {
      setState(ViewState.Busy);
    } else {
      setState(merchants.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
    return true;
  }

  void _onCharityUpdated(List<Charity> charity) {
    setState(ViewState.Busy);
    charities = charity;
    if (charities == null) {
      setState(ViewState.Busy);
    } else {
      setState(charities.length == 0
          ? ViewState.NoDataAvailable
          : ViewState.DataFetched);
    }
  }

  void _onCouponUpdated(List<Coupon> coupon) {
    setState(ViewState.Busy);
    coupons = coupon;
    if (coupons == null) {
      setState(ViewState.Busy);
    } else {
      setState(ViewState.DataFetched);
    }
  }

  String getUsedBy(String id){
    for (User user in customers) {
      if (user.id == id) {
        return user.email;
      }
    }

    return "N/A";
  }

  List<Coupon> getUsedCouponsByMerchantId(String merchantId) {
    var result = List<Coupon>();
    for (Coupon coupon in coupons){
      if (coupon.ownedBy == merchantId) {
        if (coupon.isUsed == true) {
          result.add(coupon);
        }
      }
    }

    return result;
  }
  List<Coupon> getUnusedCoupons() {
    var result = List<Coupon>();
    for (Coupon coupon in coupons){
      if (coupon.isPending == false && coupon.isUsed == false ) {
        result.add(coupon);
      }
    }
    return result;
  }

  List<Coupon> getCouponsByMerchantId(List<Coupon> coupons,String merchantId){
    setState(ViewState.Busy);
    var couponList = List<Coupon>();
    for(Coupon coupon in coupons){
      if(coupon.ownedBy == merchantId){
        couponList.add(coupon);
      }
    }
    setState(ViewState.DataFetched);
    return couponList;
  }

}