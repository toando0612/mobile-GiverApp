import 'dart:async';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/user.dart';
import 'package:rxdart/rxdart.dart';

import 'firebaseservices_provider.dart';

class Repository {

  List<Coupon> coupons;
  List<User> merchants;
  List<User> customers;
  List<Charity> charities;
  final firebaseServicesProvider = FirebaseServicesProvider();


  Future<List<Coupon>> fetchAllCoupons() => firebaseServicesProvider.fetchCouponList();

  Future<List<User>> fetchAllMerchants() => firebaseServicesProvider.fetchMerchantList();


}
