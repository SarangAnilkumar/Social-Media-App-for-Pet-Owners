import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/controllers/authentications.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;

  EditProfilePage({this.currentOnlineUserId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  TextEditingController usernameTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File file;
  bool loading = false;
  bool image=false;
  useri user;
  String path;
  String email;
  String imageUrl;

  void initState() {
    super.initState();
    getAndDisplayUserInfo();
  }

  getAndDisplayUserInfo() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot =
        await usersReference.doc(widget.currentOnlineUserId).get();
    user = useri.fromDocument(documentSnapshot);

    profileNameTextEditingController.text = user.profileName;
    bioTextEditingController.text = user.bio;
    usernameTextEditingController.text = user.username;
    imageUrl = user.url;
    email = user.email;

    setState(() {
      loading = false;
    });
  }

  updateUserData() {
      usersReference.doc(widget.currentOnlineUserId).update({
        "profileName": profileNameTextEditingController.text,
        "bio": bioTextEditingController.text,
        "username" : usernameTextEditingController.text,
        "url" : imageUrl,
      });
      print('UPDATED');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile has been updated successfully'),
        ),
      );
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        iconTheme: IconThemeData(color: Theme.of(context).disabledColor),
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
        ),
      ),
      body: loading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40,),
                      userImage(),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 13.0, left: 15),
                                    child: Text(
                                      "Profile Name",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: profileNameTextEditingController,
                                    decoration: InputDecoration(
                                      hintText: "Write Your Name here..",
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.pinkAccent,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    validator: RequiredValidator(
                                        errorText: "This Field Is Required."),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 13.0, left: 15),
                                    child: Text(
                                      "Bio",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: bioTextEditingController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.note,
                                        color: Colors.pinkAccent,
                                      ),
                                      hintText: "Write Bio here..",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    validator: MaxLengthValidator(30,
                                        errorText: "Maximum 30 Characters Allowed."),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 13.0, left: 15),
                                    child: Text(
                                      "User Name",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: usernameTextEditingController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.perm_identity_rounded,
                                        color: Colors.pinkAccent,
                                      ),
                                      hintText: "Write Username here..",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    validator:RequiredValidator(
                                        errorText: "This Field Is Required."),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 29.0, left: 50.0, right: 50.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState != null && formKey.currentState.validate()){
                              setState(() {
                                loading = true;
                              });
                              if (image==true)
                                _uploadFile();
                              else
                                updateUserData();
                              print(image);
                            }
                          },
                          child: Text(
                            "Update",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 50.0, right: 50.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: logoutUser,
                          child: Text(
                            "Logout",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  logoutUser() async {
    //await gSignIn.signOut();
    User user = auth.currentUser;
    print(user.providerData[0].providerId);
    if (user.providerData[0].providerId == 'google.com') {
      await gSignIn.disconnect();
    }
    await auth.signOut();
    Phoenix.rebirth(context);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => TestLogin()));

  }

  userImage(){
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.grey,
            backgroundImage: file == null
                ? CachedNetworkImageProvider(user.url)
                : FileImage(File(file.path)),
          ),
          InkWell(
            onTap: () => _selectPhoto(),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Change Photo',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          )
        ],
      ),
    );
  }

  Future _selectPhoto() async {
    showModalBottomSheet(
      context: context,
      builder: ((builder) => Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Choose Profile photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton.icon(
                    icon: Icon(Icons.camera, color: Colors.pink,),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    label: Text("Camera", style: TextStyle(color: Colors.pink),),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.image, color: Colors.pink,),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    label: Text("Gallery", style: TextStyle(color: Colors.pink),),
                  ),
                ])
          ],
        ),
      )),
    );
  }
  Future _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source,);
    if (pickedFile == null) {
      return;
    }
    final File imageFile = File(pickedFile.path);
    setState(() {
      this.file = imageFile;
    });
    setState(() {
      path = imageFile.path;
      image = true;
    });
  }


  Future _uploadFile() async {

    FirebaseStorage.instance.ref().child('Profile Pictures')
        .child("profile_$email.jpg").delete();

    final ref = FirebaseStorage.instance.ref().child('Profile Pictures')
        .child("profile_$email.jpg");

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });
    updateUserData();
  }
}
