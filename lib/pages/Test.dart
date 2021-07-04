import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled1/controllers/authentications.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/TestLogin.dart';

import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

class SignUp1 extends StatefulWidget {
  final String uid;
  final String email;
  SignUp1({Key key, @required this.uid, @required this.email})
      : super(key: key);
  @override
  _SignUp1State createState() => _SignUp1State(uid, email);
}

class _SignUp1State extends State<SignUp1>
    with AutomaticKeepAliveClientMixin<SignUp1> {
  File file;
  String profileId = Uuid().v4();

  final String uid;
  final String email;
  _SignUp1State(this.uid, this.email);

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String username;

  captureImageWithCamera() async {
    Navigator.pop(context);
    final _picker = ImagePicker();
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    final File imageFile = File(pickedFile.path);
    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    final _picker = ImagePicker();
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    final File imageFile = File(pickedFile.path);
    setState(() {
      this.file = imageFile;
    });
  }

  takeImage(mcontext) {
    return showDialog(
        context: mcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Profile Picture",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Capture Image with Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$profileId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 70));
    setState(() {
      file = compressedImageFile;
    });
  }

  //WHAT TO DO WITH THIS FUNCTION
  controlUploadAndSave() async {
    await compressingPhoto();

    String downloadUrl = await uploadProfilePhoto(file);

    saveProfilePicToFireStore(
        url: downloadUrl,
        name: nameController.text,
        username: usernameController.text);

    setState(() {
      file = null;
      profileId = Uuid().v4();
    });
  }

  saveProfilePicToFireStore({String url, String name, String username}) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      usersReference.doc(uid).set({
        "id": uid,
        "profileName": name,
        "username": username,
        "url": url,
        "email": email,
        "bio": "",
        "timestamp": timestamp,
      });
    }
  }

  Future<String> uploadProfilePhoto(mImageFile) async {
    UploadTask mstorageUploadTask = storageProfileReference
        .child("profile_$profileId.jpg")
        .putFile(mImageFile);
    TaskSnapshot storageTaskSnapshot = await mstorageUploadTask;

    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 20),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  imageProfile(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Name',
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Username',
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
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        controller: usernameController,
                        validator: (val) {
                          if (val.trim().length < 5 || val.isEmpty) {
                            return "Username is very short";
                          } else if (val.trim().length > 15) {
                            return "Username is very long";
                          } else {
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
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => controlUploadAndSave()));
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

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundImage: AssetImage("assets/images/profilepic.png"),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: takeImage(context),
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
}
