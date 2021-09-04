import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/PAGETEST/TestHeaderWidget.dart';
import 'package:untitled1/PAGETEST/TestHome.dart';
import 'package:untitled1/PAGETEST/TestLogin.dart';
import 'package:untitled1/PAGETEST/TestPostWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';

class TestTimeLine extends StatefulWidget {

  @override
  _TestTimeLineState createState() => _TestTimeLineState();
}

class _TestTimeLineState extends State<TestTimeLine> {
  List<TestPost> posts;
  List<String> followingList = [];
  @override
  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
  }

  getTimeline() async {
    //NEED TO CHANGE
    QuerySnapshot snapshot = await timelineReference
        .doc('timeline')
        .collection('timeline')
        .orderBy("timestamp", descending: true)
        .get();
    List<TestPost> posts =
    snapshot.docs.map((doc) => TestPost.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingReference
        .doc(firebaseUser.uid)
        .collection('userFollowing')
        .get();
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    }
    return ListView(children: posts);
  }

  logoutUser() async {
    await gSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TestLogin()));
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(
          context,
          isAppTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () => getTimeline(),
          child: buildTimeline(),
        ));
  }
}
