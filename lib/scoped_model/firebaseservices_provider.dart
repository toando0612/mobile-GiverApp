import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/donation.dart';
import 'package:giver_app/model/user.dart';


class FirebaseServicesProvider {

  Future<List<Coupon>> fetchCouponList() async {
    print("fetchCouponList");
    var couponList = List<Coupon>();
    Firestore.instance
        .collection("coupons")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((document){
        var documentData = document.data;
        documentData['id'] = document.documentID;
        couponList.add(Coupon.fromData(documentData));
      });
    });
    return couponList;
  }

  Future<List<User>> fetchMerchantList() async {

    print("fetchMerchantList");
    var merchantList = List<User>();
    Firestore.instance
        .collection("users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((document){
        var documentData = document.data;
        documentData['id'] = document.documentID;
        merchantList.add(User.fromData(documentData));
      });
    });
    return merchantList;

  }

}