import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/donation.dart';
import 'package:giver_app/model/user.dart';
import 'package:meta/meta.dart';

class FirebaseService {
  final StreamController<List<Donation>> _donationController =
      StreamController<List<Donation>>.broadcast();

  final StreamController<List<User>> _userController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<User>> _merchantController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<Charity>> _charityController =
      StreamController<List<Charity>>.broadcast();

  final StreamController<List<User>> _customerController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<Coupon>> _couponController =
      StreamController<List<Coupon>>.broadcast();

  FirebaseService() {
    Firestore.instance.collection('users').snapshots().listen(_userAdded);

    Firestore.instance
        .collection('bank')
        .document('creditBank')
        .collection('donate')
        .snapshots()
        .listen(_donationAdded);

    Firestore.instance.collection('coupons').snapshots().listen(_couponAdded);

    Firestore.instance
        .collection('charities')
        .snapshots()
        .listen(_charityAdded);
  }

  Stream<List<Donation>> get donations => _donationController.stream;

  Stream<List<Coupon>> get coupons => _couponController.stream;

  Stream<List<User>> get users => _userController.stream;

  Stream<List<User>> get customers => _customerController.stream;

  Stream<List<User>> get merchants => _merchantController.stream;

  Stream<List<Charity>> get charities => _charityController.stream;

//  void getCustomerByUid({String uid}) {
//    Firestore.instance.collection('users').document(uid).snapshots().listen(_customerInfoAdded);
//  }

  void moveCouponToPending(String couponID, String customerID) {
    Firestore.instance.collection("coupons").document(couponID).updateData({
      'isPending': true,
      'usedBy': customerID,
      'time': DateTime.now(),
    });
  }

  void denyCoupon({@required String couponID}) {
    Firestore.instance
        .collection("coupons")
        .document(couponID)
        .updateData({'usedBy': "", "isPending": false, "isUsed": false});
  }

  void redeemCoupon({@required String couponID}) {
    Firestore.instance
        .collection("coupons")
        .document(couponID)
        .updateData({'isUsed': true, "isPending": false});
  }

  void awardCredit({@required int credit, @required String customerId}) {
    DocumentReference userReference =
        Firestore.instance.collection('users').document(customerId);
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userReference);
      await transaction
          .update(snapshot.reference, {"points": snapshot['points'] + credit});
    });
  }

  

  // markFavorite(String customerId, String merchantId) async {
  //   var ds = Firestore.instance
  //       .collection('users')
  //       .document(customerId)
  //       .collection('favorites')
  //       .document(merchantId);

  //   await ds.setData({"time": DateTime.now()});
  // }

  // void unmarkFavorite(String customerId, String merchantId) async {
  //   var ds = Firestore.instance
  //       .collection('users')
  //       .document(customerId)
  //       .collection('favorites')
  //       .document(merchantId);

  //   await Firestore.instance.runTransaction((Transaction myTransaction) async {
  //     await myTransaction.delete(ds);
  //   });
  // }

  Future<void> updateMerchantData(String merchantId, String username, String phone, String address) async {
    await Firestore.instance
          .collection("users")
          .document(merchantId)
          .updateData({
        'username': username,
        'phone': phone,
        'address': address,
      });
  }


   markFavorite(String customerId, String merchantId) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'markFavorite');
    dynamic isSuccess = await callable.call(<String, dynamic> {'customerId' : customerId, 'merchantId' : merchantId, 'time' : DateTime.now().millisecondsSinceEpoch});
    
  }

  unmarkFavorite(String customerId, String merchantId) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'unmarkFavorite');
    dynamic isSuccess = await callable.call(<String, dynamic> {'customerId' : customerId, 'merchantId' : merchantId});
    
  }

  Future<bool> donate(
      {@required String charityId,
      @required String uid,
      @required int donatePoints,
      @required int userPoints}) async {
    print('userpoints: $userPoints donatepoints: $donatePoints');

    if (userPoints >= donatePoints) {
      DocumentReference userReference =
          await Firestore.instance.collection('users').document(uid);
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userReference);
        await transaction.update(
            snapshot.reference, {"points": snapshot['points'] - donatePoints});
      });

      DocumentReference charityReference =
          await Firestore.instance.collection('charities').document(charityId);
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(charityReference);
        await transaction.update(snapshot.reference,
            {"credits": snapshot['credits'] + donatePoints});
      });

      await Firestore.instance
          .collection('bank')
          .document('creditBank')
          .collection('donate')
          .add({
        'credits': donatePoints,
        'charityId': charityId,
        'customerId': uid,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      return true;
    } else {
      return false;
    }
  }

  void _donationAdded(QuerySnapshot snapshot) {
    var donate = _getDonateFromSnapshot(snapshot);
    _donationController.add(donate);
  }

  void _couponAdded(QuerySnapshot snapshot) {
    var coupon = _getCouponFromSnapshot(snapshot);
    _couponController.add(coupon);
  }

  List<Donation> _getDonateFromSnapshot(QuerySnapshot snapshot) {
    var donateHistory = List<Donation>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        donateHistory.add(Donation.fromData(documentData));
      }
    }

    return donateHistory;
  }

  List<Coupon> _getCouponFromSnapshot(QuerySnapshot snapshot) {
    var couponList = List<Coupon>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        couponList.add(Coupon.fromData(documentData));
      }
    }

    return couponList;
  }

  void _userAdded(QuerySnapshot snapshot) {
    var merchant = _getMerchantFromSnapshot(snapshot);
    var customer = _getCustomerFromSnapshot(snapshot);
    var user = _getUserFromSnapshot(snapshot);
    _merchantController.add(merchant);
    _customerController.add(customer);
    _userController.add(user);
  }

  List<User> _getUserFromSnapshot(QuerySnapshot snapshot) {
    var userList = List<User>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        userList.add(User.fromData(documentData));
      }
    }
    return userList;
  }

  List<User> _getCustomerFromSnapshot(QuerySnapshot snapshot) {
    var customerList = List<User>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        if (documentData['level'] == 1) {
          documentData['id'] = document.documentID;
          customerList.add(User.fromData(documentData));
        }
      }
    }
    return customerList;
  }

  List<User> _getMerchantFromSnapshot(QuerySnapshot snapshot) {
    var merchantList = List<User>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        if (documentData['level'] == 2) {
          documentData['id'] = document.documentID;
          merchantList.add(User.fromData(documentData));
        }
      }
    }
    return merchantList;
  }

  void _charityAdded(QuerySnapshot snapshot) {
    var charity = _getCharityFromSnapshot(snapshot);
    _charityController.add(charity);
  }

  List<Charity> _getCharityFromSnapshot(QuerySnapshot snapshot) {
    var charityList = List<Charity>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        charityList.add(Charity.fromData(documentData));
      }
    }
    return charityList;
  }

  Future<bool> editPhone(String newPhone, String uid) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .updateData({'phone': newPhone});
    return true;
  }

  Future<bool> editImageUrl(String newImageUrl, String uid) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .updateData({'imageUrl': newImageUrl});
    return true;
  }

  Future<bool> editLocation(String newAddress, String uid) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .updateData({'address': newAddress});
    return true;
  }

  Future<bool> editCategory(String newCate, String uid) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .updateData({'category': newCate});
    return true;
  }

  Future<bool> editUsername(String newUsername, String uid) async {
    await Firestore.instance
        .collection("users")
        .document(uid)
        .updateData({'username': newUsername});
//    DocumentReference reference = await Firestore.instance.collection('users').document(uid);
//    Firestore.instance.runTransaction((Transaction transaction) async {
//      DocumentSnapshot snapshot = await transaction.get(reference);
//      await transaction
//          .update(snapshot.reference, {"username": newUsername});
//    });
    return true;
  }
}
