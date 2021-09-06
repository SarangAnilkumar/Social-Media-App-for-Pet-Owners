import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled1/PetStuff/OrganizeForm.dart';
import 'package:untitled1/PetStuff/PetEventCard.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';

class PetEvents extends StatefulWidget {
  @override
  _PetEventsState createState() => _PetEventsState();
}

class _PetEventsState extends State<PetEvents> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Events", disappearedBackButton: true),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrganizeForm()));
                },
                child: Text(
                  "Organize your Own Event",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Divider(),
              List()
            ],
          ),
        ),
      ),
    );
  }

  List() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SizedBox(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('events').orderBy("RegistrationDate", descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                  return Text("No Events");
                }
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: snapshot.data.docs.map((document) {
                    return PetEventCard(location: document['Location'], Title: document['Title'],
                        name: document['Owner Name'], url: document['url'], date: document['Date of Event'],
                        members: document['members'], EventID: document['Event ID'], note: document['Note'], ownerId: document['ownerId'] ,);
                    //Text(document['Title']);
                    //PetEventCard();
                  }).toList(),
                );
              }
          ),
        ),
      ),
    );
  }
}
