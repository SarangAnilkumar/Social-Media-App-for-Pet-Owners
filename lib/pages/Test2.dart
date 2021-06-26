import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/controllers/authentications.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/TestLogin.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';


class SignUp1 extends StatefulWidget {
  final String uid;
  final String email;
  SignUp1({Key key, @required this.uid, @required this.email}) : super(key: key);
  @override
  _SignUp1State createState() => _SignUp1State(uid, email);
}

class _SignUp1State extends State<SignUp1> {

  final String uid;
  final String email;
  _SignUp1State(this.uid, this.email);

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String username;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20,top: 80, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Sign Up", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 30)),
              SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text('Name',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Your Name",
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Username',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(height: 10,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        controller: usernameController,
                        validator: (val){
                          if(val.trim().length<5 || val.isEmpty){
                            return "Username is very short";
                          }
                          else if(val.trim().length>15){
                            return "Username is very long";
                          }
                          else{
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Must be atleast 5 Characters",
                          prefixIcon: const Icon(
                            Icons.account_circle_rounded,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      usersReference.doc(uid).set({
                        "id" : uid,
                        "profileName" : nameController.text,
                        "username" : username,
                        "url" : "",
                        "email" : email,
                        "bio" : "",
                        "timestamp" : timestamp,
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home()
                          ));
                    }},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    primary: Colors.grey[900],
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(0.0),
                    textStyle: TextStyle(
                      fontSize: 20,),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.pink, Colors.purpleAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white
                        ),
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
                    Text("Already have an account?", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15)),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.pink,
                      ),
                      child: Text('Log In', style: (TextStyle(fontSize: 15))
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TestLogin()));
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

}

