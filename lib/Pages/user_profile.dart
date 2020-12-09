import 'package:asu_store/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  SharedPreferences prefs;
  UserModel user;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 200,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/user-profile.jpg'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${user.name}",
                style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 1,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${user.email}",
                    style: TextStyle(
                      fontSize: 20,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                      fontSize: 20,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "My Current Balance : ${user.currentBalance}",
                    style: TextStyle(
                      fontSize: 20,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Recharge My Balance",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 1,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text("visa/MasterCard"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text("Cash"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text("Paypal"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
