import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/PetStuff/PetProfile.dart';
import 'package:untitled1/PetStuff/PetProfile1.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/EditProfilePage.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/widgets/PostTileWidget.dart';
import 'package:untitled1/widgets/PostWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'TestLogin.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;

  ProfilePage({this.userProfileId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser?.id;
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
          padding: EdgeInsets.all(17.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Theme.of(context).primaryColorLight,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
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
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 13.0),
                child: Text(
                  user.username,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 15),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  user.profileName,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 3.0),
                child: Text(
                  user.bio,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column createColumns(String title, int count) {
    return Column(
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
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  profileButton() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if (ownProfile) {
      return editProfile(
          title: "Edit Profile", performFunction: editUserProfile,);
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
      "userProfileImg": currentUser.url,
      "timestamp": timestamp,
    });
  }

  Container editProfile({String title, Function performFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      child: TextButton(
        onPressed: performFunction,
        child: Container(
          width: 245.0,
          height: 26.0,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1.copyWith(
                color: isFollowing ? Colors.black : Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : Colors.pinkAccent,
            border: Border.all(
              color: isFollowing ? Colors.grey : Colors.pinkAccent,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
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
      appBar: header(
        context,
        titleText: "Profile", disappearedBackButton: false),
      body: ListView(
        children: <Widget>[
          createProfileTopView(),
          Divider(),
          myPet(),
          Divider(),
          createListAndGridPostOrientation(),
          Divider(
            height: 0.0,
          ),
          displayProfilePost(),
        ],
      ),
    );
  }

  myPet() {
    return Column(
      children: [
        Text("My Pets", style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold,
            fontSize: 15), ),
        SizedBox(height: 10,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TextButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PetProfile()));},
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/images/Husky.jpg"),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PetProfile1()));},
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/images/goldenretriever.jpg"),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PetProfile()));},
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/images/Husky.jpg"),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PetProfile()));},
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/images/Husky.jpg"),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PetProfile()));},
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/images/Husky.jpg"),
                ),
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
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (postOrientation == "list") {
      return Column(
        children: postsList,
      );
    }
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
          color: postOrientation == "grid"
              ? Colors.pink
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == "list"
              ? Colors.pink
              : Colors.grey,
        ),
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      this.postOrientation = orientation;
    });
  }
}
