import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/model/donation.dart';
import 'package:timeago/timeago.dart' as timeago;

class DonationHistoryItem extends StatefulWidget {
  final Donation donation;
  final String charityName;
  DonationHistoryItem({@required this.charityName, @required this.donation});

  @override
  _DonationHistoryItemState createState() => _DonationHistoryItemState();
}

class _DonationHistoryItemState extends State<DonationHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: EdgeInsets.all(5.0),
      child: Container(
        child: Card(
          color: Color.fromRGBO(204, 255, 255, 1.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Center(
                        child: Text(
                      'Name',
                      maxLines: 1,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text('TIME'),
                    ), // 15m
                  ),
                  Expanded(flex: 2, child: Center(child: Text('Credits'))),
                  Expanded(flex: 1, child: Text(''),),
                ],
              ),
              Divider(
                height: 5.0,
                color: Colors.black,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Center(
                        child: Text(
                      widget.charityName,
                      maxLines: 1,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(timeago.format(
                          Timestamp.fromMillisecondsSinceEpoch(
                                  widget.donation.time)
                              .toDate(),
                          locale: 'en_short')),
                    ), // 15m
                  ),
                  Expanded(
                      flex: 2,
                      child: Center(
                          child: Text(widget.donation.credits.toString()))),
                  Expanded(flex: 1, child: FlatButton(onPressed: null, child: Icon(Icons.description))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
