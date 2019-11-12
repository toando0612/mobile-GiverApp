import 'package:flutter/material.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/UI/widgets/coupon_history.dart';
import 'package:giver_app/UI/widgets/donation_history.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/customer_history_view_model.dart';

import 'base_view.dart';

class CustomerHistoryView extends StatelessWidget {
  const CustomerHistoryView({@required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return BaseView<CustomerHistoryViewModel>(
        builder: (context, child, model) => BusyOverlay(
          show: model.state == ViewState.Busy,
          child: TabBarView(
            children: [
              CouponHistory(model: model, uid: user.id),
              DonationHistory(model: model, uid: user.id),
            ],
          ),
        ));
  }
}
