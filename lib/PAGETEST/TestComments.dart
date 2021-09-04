import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/PAGETEST/TestHome.dart';
import 'package:untitled1/PAGETEST/TestLogin.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/ActivityFeed.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as timeago;

class TestComments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  TestComments({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

  @override
  TestCommentsState createState() => TestCommentsState(
      postId: this.postId,
      postOwnerId: this.postOwnerId,
      postMediaUrl: this.postMediaUrl,
  );
}

class TestCommentsState extends State<TestComments> {

  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;
  bool loading = false;
  useri user;
  String username;
  String url;
  String id;

  TestCommentsState({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot =
    await usersReference.doc(firebaseUser.uid).get();
    user = useri.fromDocument(documentSnapshot);

    username = user.username;
    url = user.url;
    id = user.id;

    setState(() {
      loading = false;
    });
  }




  buildTestComments() {
    return StreamBuilder(
        stream: commentsReference
            .doc(postId)
            .collection('comments')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Comment> comments = [];
          snapshot.data.docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comments,
          );
        });
  }

  addComment() {
    if (commentController.text != "") {
      commentsReference.doc(postId).collection("comments").add({
        "username": username,
        "comment": commentController.text,
        "timestamp": timestamp,
        "avatarUrl": url,
        "userId": id,
      });
      bool isNotPostOwner = postOwnerId != currentUser.id;
      if (isNotPostOwner) {
        activityFeedReference.doc(postOwnerId).collection('feedItems').add({
          "type": "comment",
          "commentData": commentController.text,
          "username": username,
          "userId": id,
          "userProfileImg": url,
          "postId": postId,
          "mediaUrl": postMediaUrl,
          "timestamp": timestamp,
        });
      }
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      header(context, titleText: "Comments", disappearedBackButton: true),
      body: Column(
        children: <Widget>[
          Expanded(child: buildTestComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write a comment...",
              ),
            ),
            trailing: OutlinedButton(
              onPressed: addComment,
              child: Text(
                "Post",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          )
        ],
      ),
    );
  }
}








class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
              Text(comment),
            ],
          ),
          leading: TextButton(
            onPressed: () => showProfile(context, profileId: firebaseUser.uid),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(avatarUrl),
            ),
          ),
          trailing: Text(timeago.format(timestamp.toDate())),
          //subtitle: Text(timeago.format(timestamp.toDate())),
        ),
      ],
    );
  }
}
