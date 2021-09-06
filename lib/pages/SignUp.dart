import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/controllers/authentications.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';

class SignUp extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<SignUp> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool uploading = false;
  File file;
  String email;
  String password;
  String name;
  String username;
  String bio;
  String path;
  String imageUrl='https://firebasestorage.googleapis.com/v0/b/petapp-c627e.appspot.com/o/Default%20Pictures%2Fprofilepic.jpg?alt=media&token=62755a74-6350-4fbe-807a-cd10941685e6';
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 20),
          child: Column(
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
              ),SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 30,
              ),
              //imageProfile(),
              userImage(),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Name",
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          validator: RequiredValidator(
                              errorText: "This Field Is Required."),
                          onChanged: (val) {
                            name = val;
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
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Username",
                            prefixIcon: const Icon(
                              Icons.perm_identity_rounded,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          validator:RequiredValidator(
                                errorText: "This Field Is Required."),
                          onChanged: (val) {
                            username = val;
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
                          'Bio',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Your Bio",
                            prefixIcon: const Icon(
                              Icons.note,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          validator: MaxLengthValidator(30,
                              errorText: "Maximum 30 Characters Allowed."),
                          onChanged: (val) {
                            bio = val;
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
                          onPressed: () {
                            if (formKey.currentState != null && formKey.currentState.validate()){
                              setState(() {
                                uploading = true;
                              });
                              _uploadFile();
                            }
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
                    ],
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
                                builder: (context) => Login()));
                      },
                    ),
                  ],
                ),
              ),
              uploading ? linearProgress() : Text(""),
            ],
          ),
        ),
      ),
    );
  }


  saveInfoToFireStore() {
      signUp(email.trim(), password, context).then((value) {
        if (value != null) {

          usersReference.doc(value.uid).set({
            "id": value.uid,
            "profileName": name,
            "username": (username == null) ? 'Un-Named' : username,
            "url": imageUrl,
            "email": email,
            "bio": (bio == null) ? '' : bio,
            "timestamp": timestamp,
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        }
      });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registered Successfully !'),
      ),
    );
  }

  userImage(){
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.grey,
            backgroundImage: file == null
                ? AssetImage("assets/images/profilepic.png",)
                : FileImage(File(file.path)),
          ),

          InkWell(
            onTap: () => _selectPhoto(),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Select Photo',
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
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        this.file = imageFile;
      });
      setState(() {
        path = imageFile.path;
      });
    }
    return;
  }

  Future _uploadFile() async {

    if(path!=null){
    final ref = profilestorageReference.child("profile_$email.jpg");
    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });
  }
    saveInfoToFireStore();
  }
}
