import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/SignUp1.dart';
import 'package:untitled1/pages/TestLogin.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';

class SignUp extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  TextEditingController mailController = TextEditingController();
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 150, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Sign Up",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 30)),
              SizedBox(
                height: 10,
              ),
              Text("Sign Up with one of the following options",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 15)),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {},
                        child: Image(
                            width: 40,
                            image: AssetImage('assets/icons/google.png')),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Image(
                            width: 40,
                            image: AssetImage('assets/icons/facebook.png')),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Email',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextFormField(
                      controller: mailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Your Email ID",
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Password',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.pinkAccent,
                        ),
                        suffix: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                width: 2000,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    signUpWithMail();
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
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
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
                    Text("Already have an account?",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontSize: 15)),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.pink,
                      ),
                      child: Text('Log In', style: (TextStyle(fontSize: 15))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TestLogin()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpWithMail() async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: mailController.text, password: passwordController.text);
      User user = result.user;
      circularProgress();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignUp1(uid: user.uid, email: user.email)));
      circularProgress();
    } catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message),
            );
          });
    }
  }
}
