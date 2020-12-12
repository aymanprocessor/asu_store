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
  List<DocumentSnapshot> documents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      setState(() {
        fbuser = auth.currentUser;
      });
    }

    init();
  }

  init() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();
    setState(() {
      documents = querySnapshot.docs
          .where((element) =>
              element.data()['from'] == fbuser.email ||
              element.data()['to'] == fbuser.email)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Transaction"),
        ),
        body: documents != null
            ? DataTable(columns: [
                DataColumn(label: Text("From")),
                DataColumn(label: Text("To")),
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Product Name")),
                DataColumn(label: Text("Price")),
              ], rows: _buildList(context))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  List<DataRow> _buildList(BuildContext context) {
    return documents.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    if (data.data()['from'].toString() == fbuser.email) {
      return DataRow(
        cells: [
          DataCell(Text(data.data()["from"])),
          DataCell(Text(data.data()["to"])),
          DataCell(Text(DateFormat("yyyy-MM-dd hh:mm aa").format(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(data.data()["date"].toString()))))),
          DataCell(Text(data.data()["productId"])),
          DataCell(Text(data.data()["price"].toString()))
        ],
        color: MaterialStateColor.resolveWith(
            (states) => Colors.red.withOpacity(0.5)),
      );
    }
    return DataRow(
      cells: [
        DataCell(Text(data.data()["from"])),
        DataCell(Text(data.data()["to"])),
        DataCell(Text(DateFormat("yyyy-MM-dd hh:mm aa").format(
            DateTime.fromMillisecondsSinceEpoch(
                int.parse(data.data()["date"].toString()))))),
        DataCell(Text(data.data()["productId"])),
        DataCell(Text(data.data()["price"].toString()))
      ],
      color: MaterialStateColor.resolveWith(
          (states) => Colors.green.withOpacity(0.5)),
    );
  }
}
