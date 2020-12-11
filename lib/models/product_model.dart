import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String owner;
  int price; // price
  String productName; // name of the product
  int rating; // rating
  String imgUrl; // product image url
  int noOfRating; // number of rating
  ProductModel(
      {this.id,
      this.owner,
      this.productName,
      this.imgUrl,
      this.price,
      this.rating,
      this.noOfRating});

  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ProductModel(
      id: snapshot.id,
      owner: snapshot.data()['owner'],
      productName: snapshot.data()['name'],
      price: snapshot.data()['price'],
      rating: snapshot.data()['rating'],
      noOfRating: snapshot.data()['noOfRating'],
      imgUrl: snapshot.data()['imgUrl'],
    );
  }
}
