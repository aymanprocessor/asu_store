import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String phone;
  String email;
  int currentBalance;

  UserModel({this.id, this.name, this.phone, this.email, this.currentBalance});

  factory UserModel.fronSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.data()['uid'],
      email: snapshot.data()['email'],
      name: snapshot.data()['name'],
      phone: snapshot.data()['phone'],
      currentBalance: snapshot.data()['current_balance'],
    );
  }

  factory UserModel.fromJson(Map json) {
    return UserModel(
      id: json['_id'],
      email: json['_id'],
      name: json['name'],
      phone: json['phone'],
      currentBalance: json['current_balance'],
    );
  }

  Map toMap() {
    var map = new Map();
    //map["_id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["phone"] = phone;
    map["current_balance"] = currentBalance;

    return map;
  }
}
