import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/PetStuff/PetEventCard.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/ActivityFeed.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;


  controlSearching(String str) {
    Future<QuerySnapshot> allUsers =
        usersReference.where("profileName", isGreaterThanOrEqualTo: str,).get();
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
          prefixIcon: Icon(
            Icons.search,
            color: Colors.pink,
            size: 30.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.pink,
            ),
            onPressed: () {
              searchTextEditingController.clear();
              return displayNoSearchResultsScreen();
            },
          ),
        ),
        onFieldSubmitted: controlSearching,
      ),
      automaticallyImplyLeading: false,
    );
  }

  displayNoSearchResultsScreen() {
    searchTextEditingController.clear();
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Icon(
                  Icons.group,
                  color: Colors.grey,
                  size: 60.0,
                ),
                Text("Search Users",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        )),
              ],
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
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchUserResult = [];
        dataSnapshot.data.docs.forEach((document) {
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
      body: futureSearchResults == null
          ? displayNoSearchResultsScreen()
          : displayUserFoundScreen(),
    );
  }
}

class UserResult extends StatelessWidget {
  final useri user;
  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.url),
              ),
              title: Text(
                user.profileName,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(
                  fontSize: 13.0,
                ),
              ),
            ),
          ),
          Divider(height: 2.0, color: Colors.grey),
        ],
      ),
    );
  }
}
