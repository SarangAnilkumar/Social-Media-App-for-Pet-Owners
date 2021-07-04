import 'package:flutter/material.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/TestLogin.dart';

class PetRegistration extends StatefulWidget {
  @override
  _PetRegistrationState createState() => _PetRegistrationState();
}

class _PetRegistrationState extends State<PetRegistration> {
  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String petType;
  String gender;

  List dogList = ["DOG"];
  List catList = ["CAT"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Pet Registration",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 30)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  children: [
                    Text("Select Your Pet"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                petType = "Dog";
                              });
                            },
                            child: Text("Dog")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                petType = "Cat";
                              });
                            },
                            child: Text("Cat")),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Text("Select Your Pet's Gender"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                gender = "Male";
                              });
                            },
                            child: Text("Male")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                gender = "Female";
                              });
                            },
                            child: Text("Female")),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    'Pet Name',
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
                      hintText: "Enter Your Pet's Name",
                      prefixIcon: const Icon(
                        Icons.pets,
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
                      //controller: usernameController,
                      validator: (val) {
                        if (val.trim().length < 4 || val.isEmpty) {
                          return "Username is very short";
                        } else if (val.trim().length > 15) {
                          return "Username is very long";
                        } else {
                          return null;
                        }
                      },
                      //onSaved: (val) => username = val,
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
                      context, MaterialPageRoute(builder: (context) => Home()));
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TestLogin()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
