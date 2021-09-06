import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled1/PetStuff/AdoptionCard.dart';
import 'package:untitled1/PetStuff/AdoptionForm.dart';
import 'package:untitled1/PetStuff/PetEventCard.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';

class AdoptPet extends StatefulWidget {
  @override
  _AdoptPetState createState() => _AdoptPetState();
}

class _AdoptPetState extends State<AdoptPet> {

  bool loading = false;

  void initState() {
    super.initState();
    getEverything();
  }

  getEverything() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('adoption').get();
    setState(() {
      loading = false;});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return circularProgress();
    }
    else return Scaffold(
      appBar: header(context, titleText: "Adopt a Pet", disappearedBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdoptionForm()));
              },
              child: Text(
                "Register Pet for Adoption",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Divider(),
            Text(
              "Dogs",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            List('Dog'),
            Divider(),
            SizedBox(height: 10,),
            Text(
              "Cats",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            List('Cat'),

          ],
        ),
      ),
    );
  }

  List(String petType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 10, left: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.65,
        child: SizedBox(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('adoption').where('PetType', isEqualTo: petType).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                  return Container(
                      child: Text("No Pets Available for Adoption"));
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.docs.map((document) {
                      return AdoptionCard(petType: document['PetType'], petBreed: document['PetBreed'], petBio: document['PetBio'], petName: document['PetName'],
                        petGender: document['PetGender'], petColor: document['PetColor'], petWeight: document['PetWeight'], petLocation: document['PetLocation'],
                        owner: document['owner'], ownerUrl: document['ownerUrl'], petId: document['PetId'], image: NetworkImage(document['url']), members: document['members']);
                      //Text(document['Title']);
                      //PetEventCard();
                    }).toList(),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
