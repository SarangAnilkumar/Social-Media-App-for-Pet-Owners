import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled1/controllers/authentications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/PAGETEST/TestHome.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/SignUp.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
useri currentUser;
final FirebaseAuth _auth = FirebaseAuth.instance;
User firebaseUser = _auth.currentUser;

class TestLogin extends StatefulWidget {
  @override
  _TestLoginState createState() => _TestLoginState();
}

class _TestLoginState extends State<TestLogin> {

  bool _isHidden = true;
  bool isSignedIn = false;
  bool loading = true;
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Scaffold login() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Log In",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 30)),
              SizedBox(
                height: 10,
              ),
              Text("Log In with one of the following options",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 15)),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: googleSignIn,
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
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Email ID",
                            prefixIcon: const Icon(
                              Icons.mail,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          validator: (_val) {
                            if (_val.isEmpty) {
                              return "Can't be empty";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            email = val;
                          },
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
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "This Field Is Required."),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required.")
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        width: 2000,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: signin,
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
                                "Log In",
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
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontSize: 15)),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.pink,
                      ),
                      child: Text('Sign Up', style: (TextStyle(fontSize: 15))),
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
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    if (isSignedIn) {
      return TestHome();
    } else {
      return login();
    }
  }

  Future<bool> googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential result = await auth.signInWithCredential(credential);

      User user = await auth.currentUser;
      print(user.uid);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TestHome()));

    }
  }

  Future<bool> signin() async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: email);
      User user = await auth.currentUser;
      // return Future.value(true);
      print(user.uid);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TestHome()));
    } catch (e) {
      // simply passing error code as a message
      print(e.code);
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_WRONG_PASSWORD':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_USER_NOT_FOUND':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_USER_DISABLED':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          showErrDialog(context, e.code);
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          showErrDialog(context, e.code);
          break;
      }
      // since we are not actually continuing after displaying errors
      // the false value will not be returned
      // hence we don't have to check the valur returned in from the signin function
      // whenever we call it anywhere
      return Future.value(null);
    }
  }
}
