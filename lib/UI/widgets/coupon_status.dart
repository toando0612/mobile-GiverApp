import 'package:flutter/material.dart';

enum CouponStatuses { Active, Used, Pending }

class CouponStatus extends StatelessWidget {
  final int status;

  CouponStatus({@required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: _getStatusColor(_getCouponStatus())),
        child: Text(_getStatusText()));
  }

  String _getStatusText() {
    return _getCouponStatus().toString().split('.').last;
  }

  CouponStatuses _getCouponStatus() {
    switch (status) {
      case 1:
        return CouponStatuses.Active;
      case 2:
        return CouponStatuses.Pending;
      case 3:
        return CouponStatuses.Used;
        
    }

    return CouponStatuses.Active;
  }

  Color _getStatusColor(CouponStatuses couponStatus) {
    switch (couponStatus) {
      case CouponStatuses.Active:
        return Colors.green;
      case CouponStatuses.Used:
        return Colors.red;
      case CouponStatuses.Pending:
        return Colors.blue;
    }

    return null;
  }
}
