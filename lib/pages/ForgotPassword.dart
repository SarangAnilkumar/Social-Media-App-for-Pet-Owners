import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {


  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 5,top: 100,left: 20),
            child: Text(
              'Name',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: Colors.grey[900], filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                labelText: 'Enter Your Name',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 5,top: 10,left: 20),
            child: Text(
              'Email',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: Colors.grey[900], filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                labelText: 'Enter Your Email ID',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
