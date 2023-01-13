import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';

class PetTinder extends StatefulWidget {
  @override
  _PetTinderState createState() => _PetTinderState();
}

class _PetTinderState extends State<PetTinder> with TickerProviderStateMixin {
  CardController controller;
  String tinderId = Uuid().v4();

  /*List itemsTemp = [];
  int itemLength = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      itemsTemp = explore_json;
      itemLength = explore_json.length;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Tinder", disappearedBackButton: true),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => selectPet()));
                    },
                    child: Text(
                      "Register Your Pet in Tinder",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  IconButton(
                      onPressed: () => print('FILTER'), icon: Icon(Icons.tune_rounded, size: 30,)),
                ],
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.77,
                child: SizedBox(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Tinder').orderBy("RegistrationDate", descending: true).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(!snapshot.hasData){
                          return Column(
                            children: [
                              Icon(Icons.map),
                              Text("No Pets"),
                            ],
                          );
                        }
                        return Container(
                          height: MediaQuery.of(context).size.height ,
                          child: Stack(
                            children: snapshot.data.docs.map((document) {
                              return tinderCards(document['url'], document['PetName'], document['DOB'].toDate(), document['PetBio'],document['PetId'], document['Interests'], document['ownerId']);
                            }).toList(),
                          ),
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  filter(){

  }

  Widget tinderCards(url, name, DateTime dob, bio, petid, interests, ownerid) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 20,),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: TinderSwapCard(
        totalNum: 1,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height * 0.75,
        minWidth: MediaQuery.of(context).size.width * 0.75,
        minHeight: MediaQuery.of(context).size.height * 0.65,
        cardBuilder: (context, index) => Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.25),
                            Colors.black.withOpacity(0),
                          ],
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15, bottom: 30, top: 15),
                        child: ClipRect(
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.67,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${dob.day}/${dob.month}/${dob.year}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                            interests.length,
                                                (indexLikes) {
                                              return Padding(
                                                padding:
                                                const EdgeInsets.only(right: 8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(30),
                                                      color: Colors.white.withOpacity(0.2)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 3,
                                                        bottom: 3,
                                                        left: 10,
                                                        right: 10),
                                                    child: Text(
                                                      interests
                                                      [indexLikes],
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Bio:",
                                      style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w700),),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      bio,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) => ProfilePage(userProfileId : ownerid)));
                                      },
                                      icon: Icon(
                                        Icons.info,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        cardController: controller = CardController(),
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          /// Get swiping card's alignment
          if (align.x < -5) {
            print("Swiped Left");
            Container(
              child: Icon(Icons.map),
            );
            FirebaseFirestore.instance.collection('Tinder').doc(petid).update({'Likes.${currentUser.id}': false});
            //Card is LEFT swiping
          } else if (align.x > 5) {
            print("Swiped Right");
            FirebaseFirestore.instance.collection('Tinder').doc(petid).update({'Likes.${currentUser.id}': true});
          }
        },
      ),
    );
  }

  selectPet(){
    return Scaffold(
      appBar: header(context, titleText: "Select Pet", disappearedBackButton: true),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Pets').doc(currentUser.id).collection('Pet').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Text("You Don't have any Pets Added");
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  padding: EdgeInsets.only(top: 10),
                  children: snapshot.data.docs.map((document) {
                    return ListTile(
                      onTap: () => {
                        handleRegistration(document['PetType'], document['PetGender'], document['PetName'], document['PetBreed'], document['DOB'],
                            document['PetBio'], document['PetLocation'], document['Pedigree'], document['Vaccinated'], document['PetId'], document['PetColor'], document['PetWeight'], document['url'], document['Interests']),
                        circularProgress()
                      },
                      leading: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        backgroundImage: NetworkImage(document['url']),
                      ),
                      title: Text(document['PetName']),
                      subtitle: Row(
                        children: [
                          Text(document['PetType']),
                          SizedBox(width: 10,),
                          document['PetGender']=='Male' ? Icon(Icons.male, color: Colors.blue,) : Icon(Icons.female, color: Colors.pink,)
                        ],
                      ),
                      trailing: Text(document['PetBreed']),
                    );
                    //Text(document['Title']);
                    //PetEventCard();
                  }).toList(),
                ),
              );
            }
        ),
      ),
    );
  }

  handleRegistration(petType,petGender,petName,petBreed,
      petDOB, petBio, location, pedigree, vaccinated, petId, petColor, petWeight, imageUrl, interests) {
    FirebaseFirestore.instance.collection('Tinder').doc(petId).set({
      'PetType': petType,
      'PetGender': petGender,
      'PetName': petName,
      'PetBreed': petBreed,
      'DOB': petDOB,
      'PetBio': petBio,
      'PetLocation': location,
      'Pedigree': pedigree,
      'Vaccinated': vaccinated,
      "PetId": petId,
      "PetColor": petColor,
      "PetWeight" : petWeight,
      "ownerId": currentUser.id,
      'url':imageUrl,
      'RegistrationDate': DateTime.now(),
      'Tinder ID': tinderId,
      'Likes' : {},
      'Interests' : interests
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registered Successfully !'),
      ),
    );
  }



}










/*
const List explore_json = [
  {
    "img": "assets/images/photo-1510771463146-e89e6e86560e.jpg",
    "name": "Al-Qaeda",
    "age": "5 Years",
    "likes": ["Pet Friendly", "Champion",],
    "Bio": "The Golden Retriever is a medium-large gun dog that was bred to retrieve shot waterfowl, such as ducks and upland game birds, during hunting and shooting parties. The name 'retriever' refers to the breed's ability to retrieve shot game undamaged due to their soft mouth.",
    "Gender": "Female"
  },
  {
    "img": "assets/images/rottweiler.jpg",
    "name": "Ghajini",
    "age": "4 Years",
    "likes": [ "Pure Breed", "Pet Friendly", "Champion",],
    "Bio": "The Rottweiler is a breed of domestic dog, regarded as medium-to-large or large. The dogs were known in German as Rottweiler Metzgerhund, meaning Rottweil butchers' dogs, because their main use was to herd livestock and pull carts laden with butchered meat to market.",
    "Gender" : "Male"
  },
  {
    "img": "assets/images/goldenretriever.jpg",
    "name": "Valerie",
    "age": "7 Years 6 Months",
    "likes": ["Champion", "Pure Breed"],
    "Bio": "The Golden Retriever is a medium-large gun dog that was bred to retrieve shot waterfowl, such as ducks and upland game birds, during hunting and shooting parties. The name 'retriever' refers to the breed's ability to retrieve shot game undamaged due to their soft mouth.",
    "Gender" : "Female"
  },
  {
    "img": "assets/images/Husky.jpg",
    "name": "Osama Bin Laden",
    "age": "2 Years",
    "likes": ["Pet Friendly", "Champion",],
    "Bio": "The Siberian Husky is a medium-sized working sled dog breed. The breed belongs to the Spitz genetic family. It is recognizable by its thickly furred double coat, erect triangular ears, and distinctive markings, and is smaller than the similar-looking Alaskan Malamute.",
    "Gender" : "Male"
  },
  {
    "img": "assets/images/Samoyed.jpg",
    "name": "Fluffy",
    "age": "8 Years",
    "likes": ["Pet Friendly", "Champion",],
    "Bio": "The Samoyed is a breed of medium-sized herding dogs with thick, white, double-layer coats. They are related to the Laika, a spitz-type dog. It takes its name from the Samoyedic peoples of Siberia. These nomadic reindeer herders bred the fluffy white dogs to help with herding.",
    "Gender" : "Female"
  },
];
*/