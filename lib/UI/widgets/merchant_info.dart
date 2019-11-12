import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/shared/text_style.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:meta/meta.dart';

import '../../service_locator.dart';

class MerchantInfo extends StatefulWidget {
  const MerchantInfo({@required this.merchant, @required this.customer});

  final User customer;
  final User merchant;

  @override
  _MerchantInfoState createState() => _MerchantInfoState();
}

class _MerchantInfoState extends State<MerchantInfo> {
  FirebaseService _firebaseService = locator<FirebaseService>();
  bool isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
      if (isFavorited == false) {
        _firebaseService.unmarkFavorite(widget.customer.id, widget.merchant.id);
      }
      _firebaseService.markFavorite(widget.customer.id, widget.merchant.id);

    });
  }

  @override
  void initState() {
   

    
    super.initState();
     checkIfLikedOrNot();
   
 }


checkIfLikedOrNot() async{
        DocumentSnapshot ds = await Firestore.instance.collection("users").document(widget.customer.id).collection('favorites').document(widget.merchant.id).get();
        this.setState(() {
          isFavorited = ds.exists;
        });

    }

  Widget get createFavoriteButton => Expanded(
      flex: 2,
      child: IconButton(
        icon: isFavorited ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border),
        onPressed: _toggleFavorite,
      ));

  @override
  Widget build(BuildContext context) {
   
    return Card(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: Text(''),flex: 1,),
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.merchant.username,
                      style: Style.merchantNameTextStyle,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.merchant.category,
                      style: Style.commonTextStyle,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Icon(Icons.location_on), flex: 1,),
                        Expanded(
                          flex: 9,
                          child: Container(
                            width: 260,
                            child: Text(
                              widget.merchant.address,
                              style: Style.baseTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          createFavoriteButton,
        ],
      ),
    );
  }
}
