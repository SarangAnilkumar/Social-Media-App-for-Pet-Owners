import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class PetTinder extends StatefulWidget {
  @override
  _PetTinderState createState() => _PetTinderState();
}

class _PetTinderState extends State<PetTinder> with TickerProviderStateMixin {
  CardController controller;

  List itemsTemp = [];
  int itemLength = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      itemsTemp = explore_json;
      itemLength = explore_json.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 80, top: 80),
      child: Container(
        height: size.height,
        child: TinderSwapCard(
          totalNum: itemLength,
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          minWidth: MediaQuery.of(context).size.width * 0.75,
          minHeight: MediaQuery.of(context).size.height * 0.6,
          cardBuilder: (context, index) => Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(itemsTemp[index]['img']),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: size.height,
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
                          padding: const EdgeInsets.all(15),
                          child: ClipRect(
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.67,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        itemsTemp[index]['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        itemsTemp[index]['age'],
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
                                              itemsTemp[index]['likes'].length,
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
                                                        itemsTemp[index]['likes']
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
                                        height: 16,
                                      ),
                                      Text(
                                        "Bio:",
                                        style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w700),),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        itemsTemp[index]['Bio'],
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
                                    width: size.width * 0.2,
                                    child: Center(
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.white,
                                        size: 28,
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
            if (align.x < -8) {
              print("Swiped Left");
              //Card is LEFT swiping
            } else if (align.x > 10) {
              print("Swiped Right");
              //Card is RIGHT swiping
            }
            // print(itemsTemp.length);
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            /// Get orientation & index of swiped card!
            if (index == (itemsTemp.length - 1)) {
              setState(() {
                itemLength = itemsTemp.length - 1;
              });
            }
          },
        ),
      ),
    );
  }
}

const List explore_json = [
  {
    "img": "assets/images/photo-1510771463146-e89e6e86560e.jpg",
    "name": "Al-Qaeda",
    "age": "5 Years",
    "likes": ["Pet Friendly", "Champion",],
    "Bio": "The Golden Retriever is a medium-large gun dog that was bred to retrieve shot waterfowl, such as ducks and upland game birds, during hunting and shooting parties. The name 'retriever' refers to the breed's ability to retrieve shot game undamaged due to their soft mouth.",
  },
  {
    "img": "assets/images/rottweiler.jpg",
    "name": "Ghajini",
    "age": "4 Years",
    "likes": [ "Pure Breed", "Pet Friendly", "Champion",],
    "Bio": "The Rottweiler is a breed of domestic dog, regarded as medium-to-large or large. The dogs were known in German as Rottweiler Metzgerhund, meaning Rottweil butchers' dogs, because their main use was to herd livestock and pull carts laden with butchered meat to market."
  },
  {
    "img": "assets/images/goldenretriever.jpg",
    "name": "Valerie",
    "age": "7 Years 6 Months",
    "likes": ["Champion", "Pure Breed"],
    "Bio": "The Golden Retriever is a medium-large gun dog that was bred to retrieve shot waterfowl, such as ducks and upland game birds, during hunting and shooting parties. The name 'retriever' refers to the breed's ability to retrieve shot game undamaged due to their soft mouth.",
  },
  {
    "img": "assets/images/Husky.jpg",
    "name": "Osama Bin Laden",
    "age": "2 Years",
    "likes": ["Pet Friendly", "Champion",],
    "Bio": "The Siberian Husky is a medium-sized working sled dog breed. The breed belongs to the Spitz genetic family. It is recognizable by its thickly furred double coat, erect triangular ears, and distinctive markings, and is smaller than the similar-looking Alaskan Malamute."
  },
  {
    "img": "assets/images/Samoyed.jpg",
    "name": "Fluffy",
    "age": "8 Years",
    "likes": ["Pet Friendly", "Champion",],
    "Bio": "The Samoyed is a breed of medium-sized herding dogs with thick, white, double-layer coats. They are related to the Laika, a spitz-type dog. It takes its name from the Samoyedic peoples of Siberia. These nomadic reindeer herders bred the fluffy white dogs to help with herding."
  },
];