/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/controllers/authentications.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/CreateAccountPage.dart';
import 'package:untitled1/pages/Home.dart';


final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = FirebaseFirestore.instance.collection("users");
final storageReference = FirebaseStorage.instance.ref().child("Post Pictures");
final postsReference = FirebaseFirestore.instance.collection("posts");

final DateTime timestamp = DateTime.now();
useri currentUser;
final FirebaseAuth _auth = FirebaseAuth.instance;
User firebaseUser = _auth.currentUser;

class qwerty extends StatefulWidget {
  @override
  _qwertyState createState() => _qwertyState();
}

class _qwertyState extends State<qwerty> {

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;

  bool isSignedIn = false;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void initState() {
    super.initState();
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error Message: " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gsignInAccount) {
      controlSignIn(gsignInAccount);

      setState(() {
        isSignedIn = false;
      });
    }).catchError((gError) {
      print("Error Message: " + gError);
    });
  }
  controlSignIn(GoogleSignInAccount signInAccount) async {
    if(signInAccount != null)
    {
      await saveUserInfoToFireStore();
      setState(() {
        isSignedIn = true;
      });
    }
    else
    {

    }
  }
  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot = await usersReference.doc(gCurrentUser.id).get();

    if (!documentSnapshot.exists){
      final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));


      usersReference.doc(gCurrentUser.id).set({
        "id" : gCurrentUser.id,
        "profileName" : gCurrentUser.displayName,
        "username" : username,
        "url" : gCurrentUser.photoUrl,
        "email" : gCurrentUser.email,
        "bio" : "",
        "timestamp" : timestamp,
      });
      documentSnapshot = await usersReference.doc(gCurrentUser.id).get();
    }

    currentUser = useri.fromDocument(documentSnapshot);
  }

  loginUser(){
    gSignIn.signIn();
  }

  logoutUser(){
    gSignIn.disconnect();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double fontScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(left: 20, right: 20, top: size.height * 0.14, bottom: size.height * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hello, \nWelcome Back", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: size.width * 0.1,)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: loginUser, child: Image(
                          width: 40,
                          image: AssetImage('assets/icons/google.png')
                      ),),

                      SizedBox(width: 40),
                      Image(
                          width: 40,
                          image: AssetImage('assets/icons/facebook.png')
                      )
                    ],
                  ),
                  SizedBox(height: 50,),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Email',
                      style: Theme.of(context).textTheme.bodyText1,

                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email or Phone number"
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password"
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Forgot Password?", style: Theme.of(context).textTheme.bodyText1,)
                ],
              ),
              Column(
                children: [
                  RaisedButton(
                    onPressed: signin,
                    elevation: 0,
                    padding: EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                  SizedBox(height: 30,),
                  Text("Create account", style: Theme.of(context).textTheme.bodyText1)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<User> signin() async {
    try {
      UserCredential result =
      await auth.signInWithEmailAndPassword(
          email: mailController.text,
          password: passwordController.text
      );
      User user = result.user;
      // return Future.value(true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home()
          ));
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



Column(
children: [
Container(
alignment: Alignment.topLeft,
padding: EdgeInsets.only(bottom: 40, top: 45, left: 10),
child: Text("Log In",
style: Theme.of(context).textTheme.headline1.copyWith(fontSize: size.width * 0.1,)),
),
Container(
alignment: Alignment.topLeft,
padding: EdgeInsets.only(bottom: 20, left: 10),
child: Text("Log In with one of the following options",
style: Theme.of(context).textTheme.headline1.copyWith(fontSize: size.width * 0.1,)),
),],
),
 */