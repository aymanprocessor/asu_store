import 'dart:math';

import 'package:asu_store/Pages/transaction.dart';
import 'package:asu_store/Pages/balance.dart';
import 'package:asu_store/Services/firestore_services.dart';
import 'package:asu_store/Services/product_services.dart';
import 'package:asu_store/Services/user_services.dart';
import 'package:asu_store/models/product_model.dart';
import 'package:asu_store/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../Services/search_service.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  SharedPreferences prefs;
  UserModel user;
  FirebaseAuth auth = FirebaseAuth.instance;

  init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = UserModel(
        name: prefs.getString('name'),
        email: prefs.getString('email'),
        phone: prefs.getString('phone'),
        currentBalance: prefs.getInt('current_balance'),
      );
    });
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String email = prefs.getString('email');
    if (auth.currentUser != null) {
      fetchUsersByEmail(email).then((value) {
        setState(() {
          user = value;
        });
      });
      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(email)
      //     .get()
      //     .then((value) {
      //   setState(() {
      //     user = UserModel.fronSnapshot(value);
      //   });
      // });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController imageUrl = TextEditingController();

  clear() {
    name.clear();
    price.clear();
    imageUrl.clear();
  }

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Scrollbar(
        child: Listener(
          onPointerSignal: (ps) {
            if (ps is PointerScrollEvent) {
              final newOffset = scrollController.offset + ps.scrollDelta.dy;
              if (ps.scrollDelta.dy.isNegative) {
                scrollController.jumpTo(math.max(0, newOffset));
              } else {
                scrollController.jumpTo(math.min(
                    scrollController.position.maxScrollExtent, newOffset));
              }
            }
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: user != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          'https://ui-avatars.com/api/?name=${user.name}&size=96'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${user.name}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 1,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: Colors.grey[700],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${user.id}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.grey[700],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${user.phone}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.attach_money,
                                        color: Colors.grey[700],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "My Current Balance : ${user.currentBalance}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Recharge My Balance",
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          changeBalance(user.id, 50)
                                              .then((value) => getUserInfo());
                                          // addBalance(50)
                                          //     .then((value) => getUserInfo());
                                        },
                                        child: Text("+50"),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          changeBalance(user.id, 100)
                                              .then((value) => getUserInfo());
                                          // addBalance(100)
                                          //     .then((value) => getUserInfo());
                                        },
                                        child: Text("+100"),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          changeBalance(user.id, 500)
                                              .then((value) => getUserInfo());
                                          // addBalance(500)
                                          //     .then((value) => getUserInfo());
                                        },
                                        child: Text("+500"),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BalancePage()));
                                    },
                                    child: Text("View Balance History",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  TransactionPage()));
                                    },
                                    child: Text("View Transaction History",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        color: Colors.blue,
                        onPressed: () {
                          Alert(
                            context: context,
                            title: "Add Item",
                            content: Column(
                              children: [
                                FormBuilder(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      FormBuilderTextField(
                                        controller: name,
                                        attribute: "productName",
                                        validators: [
                                          FormBuilderValidators.required(
                                              errorText: "Enter product name")
                                        ],
                                        decoration:
                                            InputDecoration(labelText: "Name"),
                                      ),
                                      FormBuilderTextField(
                                        controller: price,
                                        attribute: "price",
                                        validators: [
                                          FormBuilderValidators.required(
                                              errorText: "Enter product price"),
                                          FormBuilderValidators.numeric(
                                              errorText: "Enter number only")
                                        ],
                                        decoration:
                                            InputDecoration(labelText: "Price"),
                                      ),
                                      FormBuilderTextField(
                                        controller: imageUrl,
                                        attribute: "imageUrl",
                                        validators: [
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "Enter product image url"),
                                          FormBuilderValidators.url(
                                              errorText: "Enter valid url")
                                        ],
                                        decoration: InputDecoration(
                                            labelText: "Image URL"),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                color: Colors.blue,
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    ProductModel product = ProductModel(
                                        owner: user.email,
                                        productName: name.text,
                                        price: int.parse(price.text.toString()),
                                        imgUrl: imageUrl.text,
                                        rating: Random().nextInt(5),
                                        noOfRating: Random().nextInt(500),
                                        searchKey: name.text
                                            .substring(0, 1)
                                            .toLowerCase());
                                    createProduct(product).then((value) {
                                      clear();
                                      Navigator.pop(context);
                                      print(value);
                                    }).catchError((onError) => print(onError));
                                    //   FirebaseFirestore.instance
                                    //       .collection('products')
                                    //       .add({
                                    //     "name": name.text,
                                    //     "price": int.parse(price.text.toString()),
                                    //     "imgUrl": imageUrl.text,
                                    //     "rating": Random().nextInt(5),
                                    //     "noOfRating": Random().nextInt(500),
                                    //     "owner": user.email,
                                    //     "searchKey": name.text
                                    //         .substring(0, 1)
                                    //         .toLowerCase()
                                    //   }).then((value) => Navigator.pop(context));
                                  }
                                },
                                width: 170,
                              )
                            ],
                          ).show();
                        },
                        child: Text("Add Item",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 800,
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: StreamBuilder<List<ProductModel>>(
                            stream: Stream.periodic(Duration(seconds: 1))
                                .asyncMap((event) {
                              return auth.currentUser != null && user != null
                                  ? fetchMyProducts()
                                  : SearchService().getProductsWithOwner();
                            }),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                default:
                                  if (snapshot.hasData) {
                                    return GridView.builder(
                                        itemCount: snapshot.data.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          ProductModel products =
                                              snapshot.data[index];
                                          return ProductTile(
                                            id: products.id,
                                            priceInDollars: products.price,
                                            productName: products.productName,
                                            rating: products.rating,
                                            imgUrl: products.imgUrl,
                                            noOfRating: products.noOfRating,
                                          );
                                        });
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                              }
                            }),
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  double starWidth = 1.0;
  StarRating({this.rating});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          rating >= 1 ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
        SizedBox(
          width: starWidth,
        ),
        Icon(
          rating >= 2 ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
        SizedBox(
          width: starWidth,
        ),
        Icon(
          rating >= 3 ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
        SizedBox(
          width: starWidth,
        ),
        Icon(
          rating >= 4 ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
        SizedBox(
          width: starWidth,
        ),
        Icon(
          rating >= 5 ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
      ],
    );
  }
}

class ProductTile extends StatelessWidget {
  final String id;
  final int priceInDollars;
  final String productName;
  final int rating;
  final String imgUrl;
  final int noOfRating;
  ProductTile(
      {this.id,
      this.priceInDollars,
      this.imgUrl,
      this.rating,
      this.productName,
      this.noOfRating});

  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController imageUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 20,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(colors: [
                      const Color(0xff8EA2FF).withOpacity(0.8),
                      const Color(0xff557AC7).withOpacity(0.8)
                    ])),
                child: Text(
                  "\$$priceInDollars",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Image.network(
                imgUrl,
                height: 150,
                fit: BoxFit.cover,
              ),
              Text(productName),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     StarRating(
              //       rating: rating,
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Text(
              //       "($noOfRating)",
              //       style: TextStyle(color: Colors.grey, fontSize: 12),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder<ProductModel>(
                    future: fetchProductById(id),
                    builder: (context, snapshot) {
                      return RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          name.text = snapshot.data.productName;
                          price.text = snapshot.data.price.toString();
                          imageUrl.text = snapshot.data.imgUrl;
                          Alert(
                            context: context,
                            title: "Edit Item",
                            content: Column(
                              children: [
                                FormBuilder(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      FormBuilderTextField(
                                        controller: name,
                                        attribute: "productName",
                                        validators: [
                                          FormBuilderValidators.required(
                                              errorText: "Enter product name")
                                        ],
                                        decoration:
                                            InputDecoration(labelText: "Name"),
                                      ),
                                      FormBuilderTextField(
                                        controller: price,
                                        attribute: "price",
                                        validators: [
                                          FormBuilderValidators.required(
                                              errorText: "Enter product price"),
                                          FormBuilderValidators.numeric(
                                              errorText: "Enter number only")
                                        ],
                                        decoration:
                                            InputDecoration(labelText: "Price"),
                                      ),
                                      FormBuilderTextField(
                                        controller: imageUrl,
                                        attribute: "imageUrl",
                                        validators: [
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "Enter product image url"),
                                          FormBuilderValidators.url(
                                              errorText: "Enter valid url")
                                        ],
                                        decoration: InputDecoration(
                                            labelText: "Image URL"),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                color: Colors.blue,
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    // FirebaseFirestore.instance
                                    //     .collection('products')
                                    //     .doc(id)
                                    //     .update({
                                    //   "name": name.text,
                                    //   "price": int.parse(price.text.toString()),
                                    //   "imgUrl": imageUrl.text,
                                    //   "searchKey": name.text
                                    //       .substring(0, 1)
                                    //       .toLowerCase()
                                    // }).then((value) => Navigator.pop(context));

                                    updateProduct(id, {
                                      "name": name.text,
                                      "price": int.parse(price.text.toString()),
                                      "imgUrl": imageUrl.text,
                                      "searchKey": name.text
                                          .substring(0, 1)
                                          .toLowerCase()
                                    }).then((value) => Navigator.pop(context));
                                  }
                                },
                                width: 170,
                              )
                            ],
                          ).show();
                        },
                        color: Colors.blueAccent,
                        child: Container(
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, color: Colors.white),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Edit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16))
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.red,
                  child: Container(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_forever, color: Colors.white),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text("Remove",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16))
                        ],
                      ),
                    ),
                  ),
                  onPressed: () {
                    // FirebaseFirestore.instance
                    //     .collection('products')
                    //     .doc(id)
                    //     .delete();

                    deleteProduct(id);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
