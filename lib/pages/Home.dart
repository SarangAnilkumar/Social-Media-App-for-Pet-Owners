import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/pages/ActivityFeed.dart';
import 'package:untitled1/pages/Pet.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/pages/SearchPage.dart';
import 'package:untitled1/pages/TestLogin.dart';
import 'package:untitled1/pages/TimeLine.dart';



final usersReference = FirebaseFirestore.instance.collection('users');
final storageReference = FirebaseStorage.instance.ref().child('Post Pictures');
final storageProfileReference = FirebaseStorage.instance.ref().child('Profile Pictures');
final postsReference = FirebaseFirestore.instance.collection('posts');
final commentsReference = FirebaseFirestore.instance.collection('comments');
final activityFeedReference = FirebaseFirestore.instance.collection('feed');
final followersReference = FirebaseFirestore.instance.collection('followers');
final followingReference = FirebaseFirestore.instance.collection('following');
final timelineReference = FirebaseFirestore.instance.collection('timeline');
final DateTime timestamp = DateTime.now();


class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home>
{
  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 0;

  void initState(){
    super.initState();

    pageController = PageController();
  }

  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 1), curve: Curves.bounceInOut);
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLine(currentUser: currentUser),
          SearchPage(),
          Pet(),
          ActivityFeed(),
          ProfilePage(userProfileId: currentUser?.id,),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        activeColor: Colors.pink,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.pets_rounded, size: 50.0,)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
    //return ElevatedButton.icon(onPressed: logoutUser, icon: Icon(Icons.close), label: Text("Sign Out"));
  }
}
