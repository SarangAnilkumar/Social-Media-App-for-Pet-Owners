import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/pages/CreateAccountPage.dart';
import 'package:untitled1/pages/ForgotPassword.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/SignUp.dart';

class Login1 extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login1> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(bottom: 40, top: 45, left: 10),
                  child: Text(
                    'Log in',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(bottom: 20, left: 10),
                  child: Text(
                    'Log in with one of the following options',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: ElevatedButton(
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey[900],
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: ElevatedButton(
                    child: Icon(
                      Icons.facebook_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      SignUp();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey[900],
                        padding:
                            EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(bottom: 5, top: 30, left: 20),
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
                      fillColor: Colors.grey[900],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.account_circle_rounded,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(bottom: 5, top: 10, left: 20),
                  child: Text(
                    'Password',
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
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: passwordController,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.pinkAccent,
                      ),
                      fillColor: Colors.grey[900],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffix: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: Text('Forgot Password?',
                        style: (TextStyle(fontSize: 13))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                  ),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              width: 10,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  primary: Colors.grey[900],
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0.0),
                  textStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.purpleAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.pink,
                    ),
                    child: Text('SignUp', style: (TextStyle(fontSize: 15))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
