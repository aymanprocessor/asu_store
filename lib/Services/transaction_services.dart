import 'package:asu_store/models/transaction_model.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common.dart';

Future<List<TransactionModel>> fetchTransactions() async {
  final res = await http.get(apiUrl + 'transactions/');
  List<TransactionModel> trans;
  if (res.statusCode == 200) {
    //print(res.body);
    List<dynamic> body = jsonDecode(res.body);
    //print(body);
    trans = body.map((e) {
      print(e);
      return TransactionModel.fromJson(e);
    }).toList();
    print(trans[0].from);
  } else {
    print('cannnot fetch');
  }

  return trans;
}

Future<TransactionModel> createTransaction(TransactionModel body) async {
  Map<String, String> header = {"content-type": "application/json"};
  http
      .post(apiUrl + 'transactions/',
          body: json.encode(body.toMap()), headers: header)
      .then((http.Response res) {
    if (res.statusCode < 200 || res.statusCode > 400 || json == null) {
      print('Error while create user');
    } else {
      return TransactionModel.fromJson(json.decode(res.body));
    }
  });
}
