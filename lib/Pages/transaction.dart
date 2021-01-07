import 'package:asu_store/Services/product_services.dart';
import 'package:asu_store/Services/transaction_services.dart';
import 'package:asu_store/models/product_model.dart';
import 'package:asu_store/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User fbuser;
  List<TransactionModel> documents;
  List<ProductModel> products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      setState(() {
        fbuser = auth.currentUser;
      });
    }

    // init();
  }

  init() async {
    // final List<TransactionModel> trans = await fetchTransactions();

    // setState(() {
    //   documents = trans
    //       .where((element) =>
    //           element.from == fbuser.email || element.to == fbuser.email)
    //       .toList();
    // });

    // final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection('transactions')
    //     .orderBy('date', descending: true)
    //     .get();
    // setState(() {
    //   documents = querySnapshot.docs
    //       .where((element) =>
    //           element.data()['from'] == fbuser.email ||
    //           element.data()['to'] == fbuser.email)
    //       .toList();
    // });

    // final QuerySnapshot querySnapshot1 =
    //     await FirebaseFirestore.instance.collection('products').get();
    // setState(() {
    //   products = querySnapshot1.docs.toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Transaction"),
        ),
        body: FutureBuilder<List<TransactionModel>>(
            future: fetchTransactions(),
            builder: (context, snapshot) {
              // print(snapshot.data);
              return snapshot.hasData
                  ? DataTable(columns: [
                      DataColumn(label: Text("From")),
                      DataColumn(label: Text("To")),
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Product Name")),
                      DataColumn(label: Text("Price")),
                    ], rows: _buildList(context, snapshot.data))
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }

  List<DataRow> _buildList(
      BuildContext context, List<TransactionModel> documents) {
    return documents.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, TransactionModel data) {
    if (data.from.toString() == fbuser.email) {
      return DataRow(
        cells: [
          DataCell(Text(data.from)),
          DataCell(Text(data.to)),
          DataCell(Text(DateFormat("yyyy-MM-dd hh:mm aa").format(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(data.date.toString()))))),
          DataCell(Text(data.name)),
          DataCell(Text(data.price.toString()))
        ],
        color: MaterialStateColor.resolveWith(
            (states) => Colors.red.withOpacity(0.5)),
      );
    }
    return DataRow(
      cells: [
        DataCell(Text(data.from)),
        DataCell(Text(data.to)),
        DataCell(Text(DateFormat("yyyy-MM-dd hh:mm aa").format(
            DateTime.fromMillisecondsSinceEpoch(
                int.parse(data.date.toString()))))),
        DataCell(Text(data.name)),
        DataCell(Text(data.price.toString()))
      ],
      color: MaterialStateColor.resolveWith(
          (states) => Colors.green.withOpacity(0.5)),
    );
  }
}
