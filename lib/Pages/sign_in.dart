import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:asu_store/Pages/sign_up.dart';
import 'package:asu_store/Services/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg.png"),
                        fit: BoxFit.cover))),
          ),
          Align(
            alignment: Alignment.center,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                width: 450,
                height: 400,
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                  child: Column(
                    children: [
                      Text("Sign In",
                          style: TextStyle(fontSize: 25, fontFamily: 'Ubuntu')),
                      SizedBox(height: 40.0),
                      FormBuilder(
                          key: _fbKey,
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                attribute: 'email',
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    labelText: 'Email',
                                    border: outlineInputBorder),
                              ),
                              SizedBox(height: 10.0),
                              FormBuilderTextField(
                                attribute: 'password',
                                controller: password,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.vpn_key),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    labelText: 'Password',
                                    border: outlineInputBorder),
                              ),
                              SizedBox(height: 40.0),
                              ArgonButton(
                                borderRadius: 25.0,
                                height: 45.0,
                                width: MediaQuery.of(context).size.width * .8,
                                child: Text("SIGN IN",
                                    style: TextStyle(color: Colors.white)),
                                loader: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )),
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  if (_fbKey.currentState.validate()) {
                                    if (btnState == ButtonState.Idle) {
                                      startLoading();
                                      login(email.text, password.text)
                                          .then((value) {
                                        stopLoading();

                                        prefs.setString("email", value.email);
                                        prefs.setString("uid", value.uid);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home()));
                                      }).catchError((err) {
                                        stopLoading();
                                        print(err);
                                      });
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 20.0),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "Don\'t have an Account? ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Ubuntu")),
                                TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Ubuntu"),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUpPage()));
                                      })
                              ]))
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
