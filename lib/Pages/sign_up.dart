import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:asu_store/Pages/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();

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
                height: 600,
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                  child: Column(
                    children: [
                      Text("Sign Up",
                          style: TextStyle(fontSize: 25, fontFamily: 'Ubuntu')),
                      SizedBox(height: 40.0),
                      FormBuilder(
                          key: _fbKey,
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                attribute: 'name',
                                controller: name,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    labelText: 'Name',
                                    border: outlineInputBorder),
                              ),
                              SizedBox(height: 10.0),
                              FormBuilderTextField(
                                attribute: 'phone',
                                controller: phone,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    labelText: 'Phone',
                                    border: outlineInputBorder),
                              ),
                              SizedBox(height: 10.0),
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
                              SizedBox(height: 10.0),
                              FormBuilderTextField(
                                attribute: 'confirmPassword',
                                controller: confirmPassword,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.vpn_key),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    labelText: 'Confirm Password',
                                    border: outlineInputBorder),
                              ),
                              SizedBox(height: 40.0),
                              ArgonButton(
                                borderRadius: 25.0,
                                height: 45.0,
                                width: MediaQuery.of(context).size.width * .8,
                                child: Text("SIGN UP",
                                    style: TextStyle(color: Colors.white)),
                                loader: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )),
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  if (_fbKey.currentState.validate()) {
                                    if (btnState == ButtonState.Idle) {
                                    } else {}
                                  }
                                },
                              ),
                              SizedBox(height: 20.0),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "Already a Member? ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Ubuntu")),
                                TextSpan(
                                    text: "Sign In",
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
                                                    SignInPage()));
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
