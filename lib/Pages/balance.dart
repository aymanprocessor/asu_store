import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
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
        .collection('balances')
        .orderBy('date', descending: true)
        .get();
    setState(() {
      documents = querySnapshot.docs.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Balance History"),
        ),
        body: documents != null
            ? DataTable(columns: [
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Balance")),
              ], rows: _buildList(context))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  List<DataRow> _buildList(BuildContext context) {
    return documents.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(
      cells: [
        DataCell(Text(DateFormat("yyyy-MM-dd hh:mm aa").format(
            DateTime.fromMillisecondsSinceEpoch(
                int.parse(data.data()["date"].toString()))))),
        DataCell(Text(data.data()["balance"].toString())),
      ],
    );
  }
}
