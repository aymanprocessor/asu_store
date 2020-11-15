import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //     child: Image.asset(
          //   'assets/images/bg.png',
          //   fit: BoxFit.cover,
          // )),
          Container(
            color: Colors.red,
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }
}
