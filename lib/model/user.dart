

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String email;
  String imageUrl;
  int level;
  String phone;
  int points;
  String id;
  String address;
  String category;
  

  User({
    this.username,
    this.email,
    this.imageUrl,
    this.level,
    this.phone,
    this.id,
    this.points,
    this.address,
    this.category,
   
  });

  User.fromData(Map<String, dynamic> data)
      : username = data['username'],
        id = data['id'],
        imageUrl = data['imageUrl'],
        level = data['level'],
        phone = data['phone'],
        email = data['email'],
        points = data['points'],
        address = data['address'],
        category = data['category'];
        
        
}