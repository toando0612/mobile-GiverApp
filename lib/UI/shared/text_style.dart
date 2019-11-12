import 'package:flutter/material.dart';

class Style {
  static final baseTextStyle = const TextStyle(
    fontFamily: 'Poppins'
  );
  static final smallTextStyle = commonTextStyle.copyWith(
    fontSize: 12.0,
  );
  static final commonTextStyle = baseTextStyle.copyWith(
      color: const Color(0xffb6b2df),
    fontSize: 14.0,
      fontWeight: FontWeight.w400
  );
  static final titleTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.w600
  );
  static final headerTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w400
  );
  static final couponCodeTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 24.0,
    fontWeight: FontWeight.w800
  );

  static final infoTextStyle = baseTextStyle.copyWith(
      color: Colors.purple,
    fontSize: 14.0,
      fontWeight: FontWeight.w600
  );

   static final couponHistoryTextStyle = baseTextStyle.copyWith(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600
  );
  static final couponHistoryTextStyleBigger = baseTextStyle.copyWith(
      color: Colors.blueAccent,
      fontSize: 18,
      fontWeight: FontWeight.w600
  );
  static final merchantNameTextStyle = baseTextStyle.copyWith(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600
  );


  
  
  

}