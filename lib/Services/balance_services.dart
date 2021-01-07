import 'package:asu_store/models/balance_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../common.dart';

Future<List<BalanceModel>> fetchBalances() async {
  final res = await http.get(apiUrl + 'balances/');
  List<BalanceModel> balances;
  if (res.statusCode == 200) {
    List<dynamic> body = jsonDecode(res.body);
    balances = body.map((e) => BalanceModel.fromMap(e)).toList();
  } else {
    print('cannnot fetch');
  }
  print(balances);
  return balances;
}

Future createBalance(BalanceModel body) async {
  Map<String, String> header = {"content-type": "application/json"};
  http
      .post(apiUrl + 'balances/',
          body: json.encode(body.toMap()), headers: header)
      .then((http.Response res) {
    if (res.statusCode < 200 || res.statusCode > 400 || json == null) {
      print('Error while create products');
    } else {
      return BalanceModel.fromJson(json.decode(res.body));
    }
  });
}
