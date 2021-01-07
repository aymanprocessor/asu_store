import 'dart:html';

import 'package:asu_store/models/balance_model.dart';
import 'package:asu_store/models/registration_model.dart';
import 'package:asu_store/models/user_model.dart';
import 'package:asu_store/Services/balance_services.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common.dart';

Future<List<UserModel>> fetchUsers() async {
  final res = await http.get(apiUrl + 'users/');
  List<UserModel> users;
  if (res.statusCode == 200) {
    List<dynamic> body = jsonDecode(res.body);
    users = body.map((e) => UserModel.fromJson(e)).toList();
  } else {
    print('cannnot fetch');
  }

  return users;
}

Future<UserModel> fetchUsersByEmail(String email) async {
  final res = await http.get(apiUrl + 'users/byEmail/$email');
  UserModel user;
  if (res.statusCode == 200) {
    user = UserModel.fromJson(jsonDecode(res.body));
  } else {
    print('cannnot fetch');
  }
  return user;
}

Future createUser(UserModel body) async {
  Map<String, String> header = {"content-type": "application/json"};
  http
      .post(apiUrl + 'users/', body: json.encode(body.toMap()), headers: header)
      .then((http.Response res) {
    if (res.statusCode < 200 || res.statusCode > 400 || json == null) {
      print('Error while create user');
    } else {
      return UserModel.fromJson(json.decode(res.body));
    }
  });
}

Future changeBalance(String email, int amount) async {
  Map<String, String> header = {"content-type": "application/json"};
  http
      .patch(apiUrl + 'users/$email/balance/$amount', headers: header)
      .then((http.Response res) {
    if (res.statusCode < 200 || res.statusCode > 400 || json == null) {
      print('Error while create user');
    } else {
      createBalance(BalanceModel(
          balance: amount,
          date: DateTime.now().millisecondsSinceEpoch,
          owner: email));
    }
  });
}

Future<UserModel> getOwnerName(String email) async {
  UserModel user;
  final res = await http.get(apiUrl + 'users/byEmail/$email');
  if (res.statusCode == 200) {
    user = UserModel.fromJson(jsonDecode(res.body));
  } else {
    print('cannnot fetch');
  }

  return user;
}
