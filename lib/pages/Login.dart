import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/SignUp.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/controllers/authentications.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/CreateAccountPage.dart';
import 'package:untitled1/pages/ForgotPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
useri currentUser;
final FirebaseAuth _auth = FirebaseAuth.instance;
User firebaseUser = _auth.currentUser;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  bool isSignedIn = false;
  bool loading = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error Message: $gError");
    });

    gSignIn.signInSilently(suppressErrors: false).then((gsignInAccount) {
      controlSignIn(gsignInAccount);

      setState(() {
        isSignedIn = false;
      });
    }).catchError((gError) {
      print("Error Message: $gError");
    });
    setState(() {
      loading = false;
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      print('User Signed In $signInAccount');
      await saveUserInfoToFireStore();
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
    await usersReference.doc(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));

      usersReference.doc(gCurrentUser.id).set({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": (username == null) ? 'Un-Named' : username,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "bio": "",
        "timestamp": timestamp,
      });
    }
    documentSnapshot = await usersReference.doc(gCurrentUser.id).get();
    currentUser = useri.fromDocument(documentSnapshot);
  }

  loginUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.disconnect();
  }

  Scaffold login() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 150, bottom: 20),
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
              Text("Log in with one of the following options",
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
                        onPressed: loginUser,
                        child: Image(
                            width: 40,
                            image: AssetImage('assets/icons/google.png')),
                      ),
                      TextButton(
                        onPressed: loginUser,
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
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                width: 1000,
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
                        "Login",
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

  Future<User> signin() async {
    try {
      // return Future.value(true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
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
      // hence we don't have to check the value returned in from the signin function
      // whenever we call it anywhere
      return Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return circularProgress();
    } else {
      if (isSignedIn) {
        return Home();
      } else {
        return login();
      }
    }
  }
}
