import 'package:flutter/material.dart';
import 'package:untitled1/PetStuff/AdoptPet.dart';
import 'package:untitled1/PetStuff/PetTinder.dart';
import 'package:untitled1/PetStuff/PetEvents.dart';

class Pet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
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
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => PetTinder()));
                    },
                  child: button('assets/images/tinderpic.jpeg', 'Tinder', Colors.white, 30, context)
                ),
                TextButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text(''),
                        content: Text('Coming soon.....'),
                        actions: [TextButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text('OK'))],
                      ));
                    },
                    child: button('assets/images/vet.jpeg', 'Vet\n Clincs',Colors.black,15, context)
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text(''),
                        content: Text('Coming soon.....'),
                        actions: [TextButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text('OK'))],
                      ));
                    },
                    child: button('assets/images/dogspa.jpeg', 'Pet Spa', Colors.black, 20, context)
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdoptPet()));
                    },
                    child: button('assets/images/adopt.jpg', 'Pet\n Adoption', Colors.white,8, context)
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PetEvents()));
                    },
                      child: button('assets/images/dogwalk.jpg', 'Pet \nEvents', Colors.white, 30, context)
                ),
                TextButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text(''),
                        content: Text('Coming soon.....'),
                        actions: [TextButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text('OK'))],
                      ));
                    },
                    child: button('assets/images/shops.jpg', 'Shops &\nProducts', Colors.black, 10, context)
                ),
              ],
            ),
            /*PetOptions(
                itemOneTitle: "Vet \nClinics",
                itemOneImg: "assets/images/Vet.png",
                itemTwoTitle: "Places \nto eat",
                itemTwoImg: "assets/images/dogfood.png"),,*/
          ],
        ),
      ),
    ));
  }

  button (String url, String title, Color Colors, double top, BuildContext context) {
    return Container(
      width: 155,
      height: 125,
      child: ClipRRect(
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(url,)
                    ),
                  ),
                )
            ),
            Positioned(
              left: 15,
              top: top,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: TextStyle(color : Colors,fontSize: 15.5,height: 1.5)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
