import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:giver_app/model/user.dart';

class MerchantImage extends StatefulWidget {
  const MerchantImage({@required this.merchant});

  final User merchant;

  @override
  _MerchantImageState createState() => _MerchantImageState();
}

class _MerchantImageState extends State<MerchantImage> {
  double _height = 150;

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.merchant.imageUrl;
    return Container(
      width: double.infinity,
      height: _height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageUrl==null||imageUrl=='' ? ExactAssetImage('assets/merchant.jpg'):NetworkImage(imageUrl),
          fit: BoxFit.cover
        )
      ),
    );
  }
}
