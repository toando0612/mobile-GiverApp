import 'dart:async';
import 'package:giver_app/model/user.dart';
import '../scoped_model//repository.dart';
import 'package:rxdart/rxdart.dart';
import '../model/coupon.dart';

class CouponsBloc {
  final _repository = Repository();
  var _couponsFetcher = List<Coupon>();
  var _merchansFetcher = List<User>();



  List<Coupon> get allCoupons => _couponsFetcher;
  List<User> get allMerchants => _merchansFetcher;


  fetchAllCoupons() async {
    List<Coupon> couponList = await _repository.fetchAllCoupons();
    _couponsFetcher = couponList;
  }

  fetchAllMerchants() async {
    List<User> merchantList = await _repository.fetchAllMerchants();
    _merchansFetcher = merchantList;
  }



}

final bloc = CouponsBloc();