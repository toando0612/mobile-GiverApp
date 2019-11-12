import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  String id;
  String charityId;
  String customerId;
  int time;
  int credits;

  Donation({this.id, this.charityId, this.customerId, this.credits, this.time});

  Donation.fromData(Map<String, dynamic> data)
      : charityId = data['charityId'],
        id = data['id'],
        customerId = data['customerId'],
        time = data['time'],
        credits = data['credits'];
}
