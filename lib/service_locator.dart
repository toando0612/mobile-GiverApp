
import 'package:get_it/get_it.dart';
import 'package:giver_app/scoped_model/customer_history_view_model.dart';
import 'package:giver_app/scoped_model/merchant_edit_info_view_model.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'package:giver_app/scoped_model/customer_profile_view_model.dart';
import 'package:giver_app/scoped_model/merchant_profile_view_model.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:giver_app/scoped_model/home_view_model.dart';

import 'scoped_model/pending_coupon_entry_view_model.dart';
import 'scoped_model/qr_scan_view_model.dart';



GetIt locator = GetIt.instance;

void setupLocator() {
  // Register services
  locator.registerLazySingleton<FirebaseService>(() => FirebaseService());



  locator.registerSingleton(HomeViewModel());
  locator.registerSingleton(UserHomeViewModel());
  locator.registerSingleton(PendingCouponEntryViewModel());
  locator.registerSingleton(MerchantProfileViewModel());
  locator.registerSingleton(MerchantEditInfoViewModel());

  locator.registerSingleton(CustomerProfileViewModel());
  locator.registerSingleton(CustomerHistoryViewModel());

  locator.registerSingleton(QrScanViewModel());
}