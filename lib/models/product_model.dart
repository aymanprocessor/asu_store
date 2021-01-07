import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String owner;
  int price; // price
  String productName; // name of the product
  int rating; // rating
  String imgUrl; // product image url
  int noOfRating;
  String searchKey; // number of rating
  ProductModel(
      {this.id,
      this.owner,
      this.productName,
      this.imgUrl,
      this.price,
      this.rating,
      this.noOfRating,
      this.searchKey});

  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ProductModel(
      id: snapshot.id,
      owner: snapshot.data()['owner'],
      productName: snapshot.data()['name'],
      price: snapshot.data()['price'],
      rating: snapshot.data()['rating'],
      noOfRating: snapshot.data()['noOfRating'],
      imgUrl: snapshot.data()['imgUrl'],
      searchKey: snapshot.data()['searchKey'],
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      owner: json['owner'],
      productName: json['name'],
      price: json['price'],
      rating: json['rating'],
      noOfRating: json['noOfRating'],
      imgUrl: json['imgUrl'],
      searchKey: json['searchKey'],
    );
  }

  Map toMap() {
    var map = new Map();
    map["owner"] = owner;
    map["name"] = productName;
    map["price"] = price;
    map["rating"] = rating;
    map["noOfRating"] = noOfRating;
    map["imgUrl"] = imgUrl;
    map["searchKey"] = searchKey;

    return map;
  }
}
