import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:untitled1/PetStuff/PetProfile.dart';
import 'package:untitled1/PetStuff/PetProfile1.dart';
import 'package:untitled1/PetStuff/PetRegistration.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/EditProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:untitled1/widgets/PostTileWidget.dart';
import 'package:untitled1/widgets/PostWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;

  ProfilePage({this.userProfileId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser.id;
  bool isFollowing = false;
  bool loading = false;
  int countPost = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> postsList = [];
  String postOrientation = "grid";



  void initState() {
    super.initState();
    getAllProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersReference
        .doc(widget.userProfileId)
        .collection('userFollowers')
        .doc(currentOnlineUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersReference
        .doc(widget.userProfileId)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingReference
        .doc(widget.userProfileId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  createProfileTopView() {
    return FutureBuilder(
      future: usersReference.doc(widget.userProfileId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        useri user = useri.fromDocument(dataSnapshot.data);
        return Padding(
          padding: EdgeInsets.all(17.0).copyWith(top: 40),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 60.0,
                backgroundColor: Theme.of(context).primaryColorLight,
                backgroundImage: CachedNetworkImageProvider(user.url),
              ),
              Container(
                padding: EdgeInsets.only(top: 13.0) ,
                child: Text(
                  user.profileName,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 10),
                child: Text(
                  '@${user.username}',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 18),
                ),
              ),
              user.bio == "" ? SizedBox() :Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 10),
                child: Text(
                  user.bio,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 15),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            createColumns("Posts", countPost),
                            createColumns("Followers", followerCount),
                            createColumns("Following", followingCount),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            profileButton(),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  createColumns(String title, int count) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 75,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1),)]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                count.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  profileButton() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if (ownProfile) {
      return editProfile(
        title: "Edit Profile",
        performFunction: editUserProfile,
      );
    } else if (isFollowing) {
      return editProfile(
          title: "Unfollow", performFunction: handleUnfollowUser);
    } else if (!isFollowing) {
      return editProfile(title: "Follow", performFunction: handleFollowUser);
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    followersReference
        .doc(widget.userProfileId)
        .collection('userFollowers')
        .doc(currentOnlineUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    followingReference
        .doc(currentOnlineUserId)
        .collection('userFollowing')
        .doc(widget.userProfileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    activityFeedReference
        .doc(widget.userProfileId)
        .collection('feedItems')
        .doc(currentOnlineUserId)
      ..get().then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    followersReference
        .doc(widget.userProfileId)
        .collection('userFollowers')
        .doc(currentOnlineUserId)
        .set({});
    followingReference
        .doc(currentOnlineUserId)
        .collection('userFollowing')
        .doc(widget.userProfileId)
        .set({});
    activityFeedReference
        .doc(widget.userProfileId)
        .collection('feedItems')
        .doc(currentOnlineUserId)
        .set({
      "type": "follow",
      "ownerId": widget.userProfileId,
      "username": currentUser.username,
      "userId": currentOnlineUserId,
      "commentData": '',
      "mediaUrl": '',
      "postId": '',
      "userProfileImg": currentUser.url,
      "timestamp": timestamp,
    });
  }

  editProfile({String title, Function performFunction}) {
    return TextButton(
        onPressed: performFunction,
        child: Container(
          padding: EdgeInsets.all(5.0),
          width: 330.0,
          height: 35.0,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1.copyWith(
                color: isFollowing ? Colors.black : Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w800),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : Colors.pinkAccent,
            border: Border.all(
              color: isFollowing ? Colors.grey : Colors.pinkAccent,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
  }

  editUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditProfilePage(currentOnlineUserId: currentOnlineUserId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          createProfileTopView(),
          Divider(),
          myPet(),
          Divider(),
          //createListAndGridPostOrientation(),
          //Divider(height: 0.0,),
          displayProfilePost(),
        ],
      ),
    );
  }

  myPet() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;

    return Column(
      children: [
        Text(
          "My Pets",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if(ownProfile)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PetRegistration(ownerUsername: currentUser.username, ownerEmail: currentUser.email, ownerName: currentUser.profileName,)));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[700],
                    child: Icon(Icons.add,size: 30,),
                    radius: 35,
                  ),
                ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Pets').doc(widget.userProfileId).collection('Pet').orderBy("RegistrationDate", descending: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return Text("");
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data.docs.map((document) {
                          return TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PetProfile1(
                                        UserId: widget.userProfileId,
                                        PetId: document['PetId'],
                                        petBreed: document['PetBreed'],
                                        petType: document['PetType'],
                                        image: NetworkImage(document['url']),
                                        petBio: document['PetBio'],
                                        petDOB: document['DOB'],
                                        petLocation: document['PetLocation'],
                                        petName: document['PetName'],
                                        pedigree: document['Pedigree'],
                                        vaccinated: document['Vaccinated'],
                                        petGender: document['PetGender'],
                                        petColor: document['PetColor'],
                                        petWeight: document['PetWeight'],
                                      )));
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Theme.of(context).primaryColorLight,
                              backgroundImage: NetworkImage(document['url']),
                            ),
                          );
                          //Text(document['Title']);
                          //PetEventCard();
                        }).toList(),
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ],
    );
  }

  displayProfilePost() {
    if (loading) {
      return circularProgress();
    } else if (postsList.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Icon(
                Icons.photo_library,
                color: Colors.grey,
                size: 200.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else if (postOrientation == "grid") {
      List<GridTile> gridTiles = [];
      postsList.forEach((eachPost) {
        gridTiles.add(GridTile(child: PostTile(eachPost)));
      });
      return StaggeredGridView.count(
        crossAxisCount: 3,
        staggeredTiles: _staggeredTiles,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
        /*GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );*/
    } /*else if (postOrientation == "list") {
      return Column(
        children: postsList,
      );
    }*/
  }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await postsReference
        .doc(widget.userProfileId)
        .collection("usersPosts")
        .orderBy("timestamp", descending: true)
        .get();
    setState(() {
      loading = false;
      countPost = querySnapshot.docs.length;
      postsList = querySnapshot.docs
          .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
          .toList();
    });
  }

  createListAndGridPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == "grid" ? Colors.pink : Colors.grey,
        ),
        IconButton(
          onPressed: () => setOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == "list" ? Colors.pink : Colors.grey,
        ),
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      this.postOrientation = orientation;
    });
  }

  static const List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 2),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 2),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 2),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 2),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 2),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 2),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(1, 1),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(1, 1),
  ];

}

