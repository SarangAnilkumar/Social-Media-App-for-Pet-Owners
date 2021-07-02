import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/PetStuff/SearchPageDogCard.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/ActivityFeed.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage>
{
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  emptyTheTextFormField() {
    searchTextEditingController.clear();
    displayNoSearchResultsScreen();
  }

  controlSearching(String str) {
    Future<QuerySnapshot> allUsers = usersReference.where(
        "profileName", isGreaterThanOrEqualTo: str).get();
    setState(() {
      futureSearchResults = allUsers;
    });
  }


  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      title: TextFormField(
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: "Search here...",
          prefixIcon: Icon(Icons.search, color: Colors.pink, size: 30.0,),
          suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.pink,),
            onPressed: emptyTheTextFormField,),
        ),
        onFieldSubmitted: controlSearching,
      ),
    );
  }

   displayNoSearchResultsScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 30,),
            ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Icon(Icons.group, color: Colors.grey, size: 50.0,),
                  Text(
                    "Search Users",
                    textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 30,fontWeight: FontWeight.w400,)
                  ),
                ],
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            SearchPageDogCard(
                              imgScr: "assets/images/card_dog_1.png",
                              title: "Golden Retriever Meetup at Cubbon Park",
                              location: "Cubbon Park, Bangalore",
                              members: "10 members",
                              orgBy: "Narendra Modi",
                              date: "2nd Sept 2021",),
                            SearchPageDogCard(
                                imgScr: "assets/images/card_dog_1.png",
                                title: "Meet our lovely dogs walking with us",
                                location: "ISIS, Pakistan",
                                members: "8 members",
                                orgBy: "Shakespeare",
                                date: "10th Oct 2021"),
                            SearchPageDogCard(
                                imgScr: "assets/images/card_dog_1.png",
                                title: "BLA BLA BLA BLA BLA BLA BLA",
                                location: "Agra, Delhi",
                                members: "20 members",
                                orgBy: "Osama",
                                date: "15th Dec 2021"),
                          ],
                        ),
                      ),
                    ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData)
        {
          return circularProgress();
        }

        List<UserResult> searchUserResult = [];
        dataSnapshot.data.docs.forEach((document)
        {
          useri user = useri.fromDocument(document);
          UserResult userResult = UserResult(user);
          searchUserResult.add(userResult);
        });
        return ListView(children: searchUserResult);
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: searchPageHeader(),
      body: futureSearchResults == null ? displayNoSearchResultsScreen() : displayUserFoundScreen(),
    );
  }
}


class UserResult extends StatelessWidget
{
  final useri user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColorLight,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: ()=> showProfile(context, profileId: user.id),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.grey, backgroundImage: CachedNetworkImageProvider(user.url),
                ),
                title: Text(user.profileName, style: TextStyle(
                   fontSize: 16.0, fontWeight: FontWeight.bold,
                ),),
                subtitle: Text(user.username, style: TextStyle(
                   fontSize: 13.0,
                ),),
              ),
            ),
            Divider(height: 2.0, color: Colors.grey),
          ],
        ),
      );
  }
}
