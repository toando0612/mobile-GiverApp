import 'package:flutter/material.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrWidget extends StatelessWidget {
  const QrWidget({@required this.coupon});

  final Coupon coupon;

  @override
  Widget build(BuildContext context) {
    String name = coupon.code;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(name),
        leading: FlatButton(
          child: Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context),),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Scan this to redeem ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 30,),
            QrImage(
              data: coupon.id,
              gapless: true,
              size: 500,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            )
          ],
        ),
      ),
    );
  }
}
