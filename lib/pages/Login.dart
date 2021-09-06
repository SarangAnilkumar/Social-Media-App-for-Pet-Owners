import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
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

  controlSignIn(signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFireStore();
      print('User Signed In $signInAccount');
      setState(() {
        isSignedIn = true;
      });
    }
  }



  Future<bool> _logInWithMail() async {
    final form = formkey.currentState;
    if (form.validate()){
    setState(() {
      loading = true;
    });
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = await auth.currentUser;
      // return Future.value(true);
      print(user.uid);
      DocumentSnapshot documentSnapshot = await usersReference.doc(user.uid)
          .get();
      if (!documentSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User does not Exist, Create Account'),
          ),
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignUp()));
      }
      documentSnapshot = await usersReference.doc(user.uid).get();
      currentUser = useri.fromDocument(documentSnapshot);
      setState(() {
        isSignedIn = true;
      });
    } on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential' :
          title = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential' :
          title = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed' :
          title = 'This operation is not allowed';
          break;
        case 'user-disabled' :
          title = 'The user you tried to login is disabled';
          break;
        case 'user-not-found' :
          title = 'User not found';
          break;
        case 'wrong-password' :
          title = 'Incorrect Password';
          break;
      }
      showDialog(context: context, builder: (context) =>
          AlertDialog(
            title: Text('Log In with Email failed'),
            content: Text(title),
            actions: [TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('OK'))
            ],
          ));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
  }

  void _logInWithFacebook() async {
    setState(() {
      loading = true;
    });
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      User user = await auth.currentUser;
      print(user.uid);
      DocumentSnapshot documentSnapshot = await usersReference.doc(user.uid).get();

      if (!documentSnapshot.exists) {
        final username = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateAccountPage()));

        usersReference.doc(user.uid).set({
          "id": user.uid,
          "profileName": userData['name'],
          "username": (username == null) ? 'Un-Named' : username,
          "url": userData['picture']['data']['url'],
          "email": userData['email'],
          "bio": "",
          "timestamp": timestamp,
        });
      }
      setState(() {
        isSignedIn = true;
      });

      documentSnapshot = await usersReference.doc(user.uid).get();
      currentUser = useri.fromDocument(documentSnapshot);
    }
    on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential' :
          title = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential' :
          title = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed' :
          title = 'This operation is not allowed';
          break;
        case 'user-disabled' :
          title = 'The user you tried to login is disabled';
          break;
        case 'user-not-found' :
          title = 'User not found';
          break;
        case 'wrong-password' :
          title = 'Wrong Password';
          break;
      }
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('Log In with FaceBook failed'),
        content: Text(title),
        actions: [TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text('OK'))],
      ));
    }finally {
      setState(() {
        loading = false;
      });
    }
  }

  saveUserInfoToFireStore() async {
    setState(() {
      loading = true;
    });
    try{
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
      final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
      DocumentSnapshot documentSnapshot = await usersReference.doc(user.uid).get();
      if (!documentSnapshot.exists) {
        final username = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateAccountPage()));
        usersReference.doc(user.uid).set({
          "id": user.uid,
          "profileName": gCurrentUser.displayName,
          "username": (username == null) ? 'Un-Named' : username,
          "url": gCurrentUser.photoUrl,
          "email": gCurrentUser.email,
          "bio": "",
          "timestamp": timestamp,
        });
      }
      documentSnapshot = await usersReference.doc(user.uid).get();
      currentUser = useri.fromDocument(documentSnapshot);
    }
    }
    on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential' :
          title = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential' :
          title = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed' :
          title = 'This operation is not allowed';
          break;
        case 'user-disabled' :
          title = 'The user you tried to login is disabled';
          break;
        case 'user-not-found' :
          title = 'User not found';
          break;
        case 'wrong-password' :
          title = 'Wrong Password';
          break;
      }
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('Log In with FaceBook failed'),
        content: Text(title),
        actions: [TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text('OK'))],
      ));
    }finally {
      setState(() {
        loading = false;
      });
    }
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
                    onPressed: loginUser,
                    child: Image(
                        width: 40,
                        image: AssetImage('assets/icons/google.png')),
                  ),
                  TextButton(
                    onPressed: _logInWithFacebook,
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
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "This Field Is Required."),
                            EmailValidator(
                                errorText: "Invalid Email format")
                          ]),
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
                          onPressed: _logInWithMail,
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
