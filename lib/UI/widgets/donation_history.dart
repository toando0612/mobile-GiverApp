import 'package:flutter/material.dart';
import 'package:giver_app/model/donation.dart';
import 'package:giver_app/scoped_model/customer_history_view_model.dart';
import 'donation_history_item.dart';

class DonationHistory extends StatefulWidget {
  final CustomerHistoryViewModel model;
  final String uid;

  DonationHistory({@required this.model, @required this.uid});

  @override
  _DonationHistoryState createState() => _DonationHistoryState();
}
class _DonationHistoryState extends State<DonationHistory> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    var donations = widget.model.donations;
    return Container(
      child: ListView.builder(
          itemCount: donations.length,
          itemBuilder: (BuildContext context, rowNumber) {
            var donation = widget.model.donations[rowNumber];
            String name = widget.model
                .getCharityNameById(widget.model.charities, donation.charityId);
            return DonationHistoryItem(
              charityName: name,
              donation: donation,
            );
          }),
    );
  }
}
