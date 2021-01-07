import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import '../common.dart';
import '../models/product_model.dart';
import 'dart:convert';

class SearchService {
  Future<List<ProductModel>> searchByName(String searchField) async {
    List<ProductModel> products;
    final res = await http
        .get(apiUrl + 'products/search/${searchField.substring(0, 1)}');

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      products = body.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      print('cannnot fetch');
    }
    return products;
    // return FirebaseFirestore.instance
    //     .collection('products')
    //     .where('searchKey', isEqualTo: searchField.substring(0, 1))
    //     .get();
  }

  Future<List<ProductModel>> getProductsWithoutOwner() async {
    String email = FirebaseAuth.instance.currentUser.email;
    List<ProductModel> products;

    final res =
        await http.get(apiUrl + 'products/withoutOwnerProducts/?email=$email');

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      products = body.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      print('cannnot fetch');
    }

    return products;

    // return FirebaseFirestore.instance
    //     .collection('products')
    //     .where('owner', isNotEqualTo: email)
    //     .get();
  }

  Future<List<ProductModel>> getProductsWithOwner() async {
    List<ProductModel> products;

    final res = await http.get(apiUrl + 'products/');

    if (res.statusCode == 200) {
      print(res.body);
      List<dynamic> body = jsonDecode(res.body);
      products = body.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      print('cannnot fetch');
    }

    return products;
  }
}
