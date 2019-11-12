import 'package:giver_app/enum/view_state.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/donation.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/services/firebase_service.dart';
import '../service_locator.dart';
import 'base_model.dart';
export 'package:giver_app/enum/view_state.dart';


class CustomerHistoryViewModel extends BaseModel{
  FirebaseService _firebaseService = locator<FirebaseService>();

  List<Coupon> coupons;
  List<Donation> donations;
  List<Charity> charities;


  CustomerHistoryViewModel() {
    _firebaseService.coupons.listen(_onCouponUpdated);
    _firebaseService.donations.listen(_onDonationUpdated);
    _firebaseService.charities.listen(_onCharityUpdated);

  }

  String getCharityNameById(List<Charity> charityList ,String id){
    for(Charity charity in charityList){
      if(charity.id == id){
        return charity.name;
      }
    }
  }

  void _onDonationUpdated(List<Donation> donation) {
    donations = donation;
    if (donations == null) {
      setState(ViewState.Busy);
    } else {
      setState(ViewState.DataFetched);
    }
  }

  void _onCharityUpdated(List<Charity> charity){
    charities = charity;
    if (charities == null) {
      setState(ViewState.Busy);
    } else {
      setState(ViewState.DataFetched);
    }
  }

  void _onCouponUpdated(List<Coupon> coupon) {
    coupons = coupon;
    if (coupons == null) {
      setState(ViewState.Busy);
    } else {
      setState(ViewState.DataFetched);
    }
  }

  List<Donation> getDonateHistory(List<Donation> donationList,String uid) {
    setState(ViewState.Busy);
    var finalList = List<Donation>();
    for(Donation donation in donationList){
      if(donation.customerId == uid){
        finalList.add(donation);
      }
    }
    setState(ViewState.DataFetched);
    return finalList;
  }




  List<Coupon> getUsedCoupons(List<Coupon> couponList,String uid) {
    setState(ViewState.Busy);
    var finalList = List<Coupon>();
    for(Coupon coupon in couponList){
      if(coupon.isUsed == true && coupon.usedBy == uid && coupon.isPending == false){
        finalList.add(coupon);
      }
    }
    setState(ViewState.DataFetched);
    return finalList;
  }
}