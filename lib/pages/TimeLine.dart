import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/SearchPage.dart';
import 'package:untitled1/pages/TestLogin.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:untitled1/widgets/PostWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';

class TimeLine extends StatefulWidget {
  final useri currentUser;
  TimeLine({ this.currentUser });
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  List<Post> posts;
  List<String> followingList = [];
  @override
  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
  }

  getTimeline() async {
    //NEED TO CHANGE
    QuerySnapshot snapshot = await timelineReference.doc('timeline').collection('timeline').orderBy("timestamp", descending: true).get();
    List<Post> posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingReference.doc(currentUser.id).collection('userFollowing').get();
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });


  }

  buildTimeline(){
    if(posts == null) {
      return circularProgress();
    }
    return ListView(children: posts);
  }

  logoutUser() async {

    await gSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> TestLogin()));
  }



  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true,),
      body: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: buildTimeline(),
      )
    );
  }
}
