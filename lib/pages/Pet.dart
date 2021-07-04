import 'package:flutter/material.dart';
import 'package:untitled1/PetStuff/PetOptions.dart';

class Pet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Find anything you need for your pets",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold, height: 1.5),
                )),
            SizedBox(
              height: 30,
            ),
            PetOptions(
                itemOneTitle: "Vet \nClinics",
                itemOneImg: "assets/images/Vet.png",
                itemTwoTitle: "Places \nto eat",
                itemTwoImg: "assets/images/dogfood.png"),
            PetOptions(
                itemOneTitle: "Places \nto walk",
                itemOneImg: "assets/images/card_3.png",
                itemTwoTitle: "Spas \n& Salons",
                itemTwoImg: "assets/images/dogspa.png"),
            PetOptions(
                itemOneTitle: "Shops \n& Products",
                itemOneImg: "assets/images/Webp.net-resizeimage.png",
                itemTwoTitle: "Walk \ngroups ",
                itemTwoImg: "assets/images/dogwalk.png"),
          ],
        ),
      ),
    ));
  }
}
