import 'dart:convert';

import 'package:asu_store/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../common.dart';

Future<List<ProductModel>> fetchProducts() async {
  final res = await http.get(apiUrl + 'products');
  List<ProductModel> products;
  if (res.statusCode == 200) {
    List<dynamic> body = jsonDecode(res.body);
    products = body.map((e) => ProductModel.fromJson(e)).toList();
  } else {
    print('cannnot fetch');
  }
  return products;
}

Future<List<ProductModel>> fetchMyProducts() async {
  String email = FirebaseAuth.instance.currentUser.email;
  List<ProductModel> products;

  final res =
      await http.get(apiUrl + 'products/GetOwnerProducts/?email=$email');

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

Future<ProductModel> fetchProductById(String id) async {
  final res = await http.get(apiUrl + 'products/$id');
  ProductModel products;
  if (res.statusCode == 200) {
    dynamic body = jsonDecode(res.body);
    products = ProductModel.fromJson(body);
  } else {
    print('cannnot fetch');
  }

  return products;

  // return FirebaseFirestore.instance
  //     .collection('products')
  //     .where('owner', isNotEqualTo: email)
  //     .get();
}

Future createProduct(ProductModel body) async {
  Map<String, String> header = {"content-type": "application/json"};
  http
      .post(apiUrl + 'products/',
          body: json.encode(body.toMap()), headers: header)
      .then((http.Response res) {
    if (res.statusCode < 200 || res.statusCode > 400 || json == null) {
      print('Error while create products');
    } else {
      return ProductModel.fromJson(json.decode(res.body));
    }
  });
}

Future updateProduct(String id, Map body) async {
  Map<String, String> header = {"content-type": "application/json"};
  http
      .patch(apiUrl + 'products/$id', body: json.encode(body), headers: header)
      .then((http.Response res) {
    if (res.statusCode < 200 || res.statusCode > 400 || json == null) {
      print('Error while create products');
    } else {
      return json.decode(res.body);
    }
  });
}

Future deleteProduct(String id) async {
  Map<String, String> header = {"content-type": "application/json"};
  http
      .delete(apiUrl + 'products/$id', headers: header)
      .then((http.Response res) {
    if (res.statusCode < 200 || res.statusCode > 400 || json == null) {
      print('Error while create products');
    } else {
      return json.decode(res.body);
    }
  });
}
