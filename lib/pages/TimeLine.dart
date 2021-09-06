import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:untitled1/widgets/PostWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {

  List<Post> posts;
  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapshot =
    await timelineReference.orderBy("timestamp", descending: true).get();
    List<Post> posts =
    snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    }
    return ListView(children: posts);
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(
          context,
          isAppTitle: true,
        ),
        body: RefreshIndicator(
          color: Colors.pink,
          onRefresh: () => getTimeline(),
          child: buildTimeline(),
        ));
  }
}
