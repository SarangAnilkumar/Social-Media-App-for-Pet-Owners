import 'dart:async';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';


class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String username;
  bool loading = false;

  submitUsername() {
    final form = _formKey.currentState;
      form.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome ' + username),
        ),
      );
      // SnackBar snackBar = SnackBar(content: Text("Welcome " +username));
      // _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });

  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      body: loading
          ? circularProgress()
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Set up a username",
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                onChanged: (value) {
                  username = value;
                },
                // style: TextStyle(color: Colors.white),
                validator: RequiredValidator(
                    errorText: "This Field Is Required."),
                onSaved: (val) => username = val,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  labelStyle: TextStyle(fontSize: 16.0),
                  hintText: "Must be atleast 5 Characters",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState != null && _formKey.currentState.validate()){
                submitUsername();
              }
            },
            child: Container(
              height: 55.0,
              width: 260.0,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
