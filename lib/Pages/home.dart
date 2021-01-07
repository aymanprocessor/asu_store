import 'package:asu_store/Pages/sign_up.dart';
import 'package:asu_store/Pages/user_profile.dart';
import 'package:asu_store/Services/auth.dart';
import 'package:asu_store/Services/firestore_services.dart';
import 'package:asu_store/Services/product_services.dart';
import 'package:asu_store/Services/transaction_services.dart';
import 'package:asu_store/Services/user_services.dart';
import 'package:asu_store/fake_data/products_data.dart';
import 'package:asu_store/models/product_model.dart';
import 'package:asu_store/models/transaction_model.dart';
import 'package:asu_store/models/user_model.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Services/search_service.dart';
import '../Services/user_services.dart';
import 'dart:math' as math;
import 'sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ProductModel> products = new List();
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel user;
  User fbuser;

  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    products = getProducts();
    if (auth.currentUser != null) {
      setState(() {
        fbuser = auth.currentUser;
      });
    }
    initiateSearch("");
  }

  Stream<User> getaaa() {
    Future.delayed(Duration(seconds: 3));
    return FirebaseAuth.instance.authStateChanges();
  }

  List<ProductModel> queryResultSet = [];
  List<ProductModel> tempSearchStore = [];

  initiateSearch(String value) {
    if (value.length == 0) {
      tempSearchStore = [];
      queryResultSet = [];
      if (auth.currentUser != null) {
        SearchService().getProductsWithoutOwner().then((element) {
          element.forEach((element) {
            setState(() {
              queryResultSet = [];
              tempSearchStore.add(element);
            });
          });
        });
      } else {
        SearchService().getProductsWithOwner().then((element) {
          element.forEach((element) {
            setState(() {
              queryResultSet = [];
              tempSearchStore.add(element);
            });
          });
        });
      }
    }
    var capitalizedValue =
        value != "" ? value.substring(0, 1) + value.substring(1) : "";

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((List<ProductModel> docs) {
        for (int i = 0; i < docs.length; ++i) {
          queryResultSet.add(docs[i]);
        }
        setState(() {
          tempSearchStore = queryResultSet;
        });
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element.productName.toLowerCase().startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Store"),
          actions: [
            StreamBuilder<User>(
              stream: getaaa(),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Container();
                if (fbuser != null) {
                  return StreamBuilder<UserModel>(
                      stream: Stream.periodic(Duration(milliseconds: 500))
                          .asyncMap((event) =>
                              fetchUsersByEmail(snapshot.data.email)),
                      // FirebaseFirestore.instance
                      //     .collection('users')
                      //     .doc(snapshot.data.email)
                      //     .snapshots(),
                      builder: (context, doc) {
                        if (!doc.hasData) return CircularProgressIndicator();
                        user = doc.data;
                        return Row(
                          children: [
                            FirebaseAuth.instance.currentUser != null
                                ? Row(
                                    children: [
                                      Text("Balance : ${user.currentBalance}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 30),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfile()));
                                        },
                                        child: Row(
                                          children: [
                                            Text("${user.name}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Container(
                                              margin: EdgeInsets.all(5.0),
                                              height: 45,
                                              width: 45,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.black,
                                                radius: 30.0,
                                                child: CircleAvatar(
                                                  radius: 28.0,
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      'https://ui-avatars.com/api/?name=${user.name}',
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )),
                            SizedBox(width: 30.0),
                            InkWell(
                              onTap: () {
                                if (snapshot != null) {
                                  logout().then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 5.0),
                                  Text("Logout",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (FirebaseAuth.instance.currentUser == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()));
                          } else {
                            initiateSearch("");
                            setState(() {
                              fbuser = FirebaseAuth.instance.currentUser;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.login),
                            SizedBox(width: 5.0),
                            Text("Login",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(width: 30.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.person_add),
                            SizedBox(width: 5.0),
                            Text("Sign Up",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(width: 30.0),
            // Padding(
            //   padding: const EdgeInsets.only(right: 10.0),
            //   child: Badge(
            //     shape: BadgeShape.circle,
            //     badgeColor: Colors.red,
            //     badgeContent: Text('0', style: TextStyle(color: Colors.white)),
            //     position: BadgePosition.topEnd(top: 3),
            //     child: Icon(
            //       Icons.shopping_cart,
            //       size: 35,
            //     ),
            //   ),
            // ),
            // SizedBox(width: 20.0),
          ],
        ),
        body: Scrollbar(
          isAlwaysShown: true,
          controller: scrollController,
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
              physics: ScrollPhysics(),
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  // here we will add our containers
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          offset: Offset(5.0, 5.0),
                          blurRadius: 5.0,
                          color: Colors.black87.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 9),
                              child: TextField(
                                onChanged: (str) {
                                  initiateSearch(str);
                                },
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  hintText: "Search",
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  /// Best Selling
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Best Selling",
                          style: TextStyle(color: Colors.black87, fontSize: 22),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("This week")
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<User>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, user) {
                        return tempSearchStore.isNotEmpty
                            ? Container(
                                padding: EdgeInsets.only(left: 25, right: 25),
                                child: GridView.builder(
                                    itemCount: tempSearchStore.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      ProductModel products =
                                          tempSearchStore[index];

                                      return FutureBuilder<UserModel>(
                                          future: getOwnerName(products.owner),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return ProductTile(
                                                  id: products.id,
                                                  priceInDollars:
                                                      products.price,
                                                  productName:
                                                      products.productName,
                                                  rating: products.rating,
                                                  imgUrl: products.imgUrl,
                                                  noOfRating:
                                                      products.noOfRating,
                                                  ownerEmail: products.owner,
                                                  owner: snapshot.data.name);
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          });
                                    }))
                            : Text("No Data");
                      }),
                ],
              ),
            ),
          ),
        ));
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
  final String owner;
  final String ownerEmail;
  ProductTile(
      {this.id,
      this.priceInDollars,
      this.imgUrl,
      this.rating,
      this.productName,
      this.noOfRating,
      this.ownerEmail,
      this.owner});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 25,
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
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(colors: [
                            Colors.purple[500].withOpacity(0.8),
                            Colors.purple[800].withOpacity(0.8),
                          ])),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          "by $owner",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Image.network(
                  imgUrl,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Text(productName),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StarRating(
                      rating: rating,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "($noOfRating)",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<User>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (BuildContext context, AsyncSnapshot<User> user) {
                    if (user.hasData) {
                      return FutureBuilder<UserModel>(
                          future: fetchUsersByEmail(user.data.email),
                          // stream: FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(user.data.email)
                          //     .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(child: CircularProgressIndicator());
                            return RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () {
                                if (int.parse(snapshot.data.currentBalance
                                        .toString()) >=
                                    priceInDollars) {
                                  Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "Buy $productName",
                                      content: Text("Buy this item?"),
                                      buttons: [
                                        DialogButton(
                                          color: Colors.red,
                                          child: Text(
                                            "BUY",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            createTransaction(TransactionModel(
                                                    to: user.data.email,
                                                    from: ownerEmail,
                                                    date: DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    productId: id,
                                                    name: productName,
                                                    price: priceInDollars))
                                                .then((value) {
                                              updateProduct(id,
                                                  {"owner": user.data.email});

                                              changeBalance(user.data.email,
                                                  -priceInDollars);

                                              Navigator.pop(context);
                                            });

                                            // FirebaseFirestore.instance
                                            //     .collection('transactions')
                                            //     .add({
                                            //   "to": user.data.email,
                                            //   "from": ownerEmail,
                                            //   "date": DateTime.now()
                                            //       .millisecondsSinceEpoch,
                                            //   "productId": id,
                                            //   "name": productName,
                                            //   "price": priceInDollars
                                            // }).then((value) {
                                            //   FirebaseFirestore.instance
                                            //       .collection('products')
                                            //       .doc(id)
                                            //       .update({
                                            //     "owner": user.data.email
                                            //   });

                                            //   FirebaseFirestore.instance
                                            //       .collection('users')
                                            //       .doc(user.data.email)
                                            //       .update({
                                            //     "current_balance":
                                            //         FieldValue.increment(
                                            //             -priceInDollars)
                                            //   });
                                            //Navigator.pop(context);
                                            // });
                                          },
                                          width: 170,
                                        )
                                      ]).show();
                                } else {
                                  Alert(
                                      context: context,
                                      type: AlertType.error,
                                      title: "Balance is not enough",
                                      content: Text(
                                          "Please recharge your balance",
                                          style: TextStyle(color: Colors.red)),
                                      onWillPopActive: true,
                                      buttons: [
                                        DialogButton(
                                          color: Colors.red,
                                          child: Text(
                                            "RECHARGE",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserProfile()));
                                          },
                                          width: 170,
                                        )
                                      ]).show();
                                }
                              },
                              color: Colors.blueAccent,
                              child: Container(
                                width: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.monetization_on_outlined,
                                          color: Colors.white),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text("Buy",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      ///////////////////////////////////////////

                      return RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                        color: Colors.blueAccent,
                        child: Container(
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.monetization_on_outlined,
                                    color: Colors.white),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Buy",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16))
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
