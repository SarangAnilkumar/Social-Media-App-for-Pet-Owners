import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/ActivityFeed.dart';
import 'package:untitled1/PetStuff/Pet.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/pages/SearchPage.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/pages/TimeLine.dart';

final usersReference = FirebaseFirestore.instance.collection('users');
final petReference = FirebaseFirestore.instance.collection('Pets');
final storageReference = FirebaseStorage.instance.ref().child('Post Pictures');
final petstorageReference = FirebaseStorage.instance.ref().child('Pet Pictures');
final peteventstorageReference = FirebaseStorage.instance.ref().child('Event Pictures');
final profilestorageReference = FirebaseStorage.instance.ref().child('Profile Pictures');
final postsReference = FirebaseFirestore.instance.collection('posts');
final commentsReference = FirebaseFirestore.instance.collection('comments');
final activityFeedReference = FirebaseFirestore.instance.collection('feed');
final followersReference = FirebaseFirestore.instance.collection('followers');
final followingReference = FirebaseFirestore.instance.collection('following');
final timelineReference = FirebaseFirestore.instance.collection('timeline');
final eventReference = FirebaseFirestore.instance.collection('events');
final DateTime timestamp = DateTime.now();

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 0;

  void initState() {
    super.initState();

    pageController = PageController();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 1), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLine(),
          SearchPage(),
          Pet(),
          ActivityFeed(),
          ProfilePage(userProfileId: currentUser.id),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: getPageIndex,
        //currentIndex: getPageIndex,
        onTap: onTapChangePage,
        height: 50,
        backgroundColor: Colors.pink,
        buttonBackgroundColor: Theme.of(context).primaryColorLight,
        color: Theme.of(context).primaryColorLight,
        animationDuration: Duration(
            milliseconds: 300
        ),
        //activeColor: Colors.pink,
        //inactiveColor: Colors.grey,
        items: [
          Icon(Icons.home, ),
          Icon(Icons.search,),
          Icon(Icons.pets_rounded, size: 35, ),
          Icon(Icons.favorite,),
          Icon(Icons.person, )
          /*BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.pets_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),*/
        ],
      ),
    );
    //return ElevatedButton.icon(onPressed: logoutUser, icon: Icon(Icons.close), label: Text("Sign Out"));
  }
}