import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/ActivityFeed.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  Comments({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

  @override
  CommentsState createState() => CommentsState(
    postId: this.postId,
    postOwnerId: this.postOwnerId,
    postMediaUrl: this.postMediaUrl,
  );
}

class CommentsState extends State<Comments> {

  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;
  bool loading = false;
  useri user;
  String username;
  String url;
  String id;
  String commentId = Uuid().v4();

  CommentsState({
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
    await usersReference.doc(currentUser.id).get();
    user = useri.fromDocument(documentSnapshot);

    username = user.username;
    url = user.url;
    id = user.id;

    setState(() {
      loading = false;
    });
  }

  buildComments() {
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
      commentsReference.doc(postId).collection("comments").doc(commentId).set({
        "username": username,
        "comment": commentController.text,
        "timestamp": timestamp,
        "avatarUrl": url,
        "postId": postId,
        "ownerId": postOwnerId,
        "commentId": commentId,
        "userId": id,
      });
      bool isNotPostOwner = postOwnerId != currentUser.id;
      if (isNotPostOwner) {
        activityFeedReference.doc(postOwnerId).collection('feedItems').doc(commentId).set({
          "type": "comment",
          "commentData": commentController.text,
          "username": username,
          "userId": id,
          "ownerId": postOwnerId,
          "userProfileImg": url,
          "commentId": commentId,
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
      appBar: header(context, titleText: "Comments", disappearedBackButton: true),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
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
  final String postId;
  final String commentId;
  final String ownerId;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.postId,
    this.commentId,
    this.ownerId,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      postId: doc['postId'],
      comment: doc['comment'],
      commentId : doc['commentId'],
      ownerId: doc['ownerId'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  deleteComment() {
    activityFeedReference.doc(ownerId).collection('feedItems').doc(commentId).delete();
      commentsReference.doc(postId).collection("comments").doc(commentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    bool isCommentOwner = userId == currentUser.id;
    return Column(
      children: <Widget>[
        ListTile(
          onLongPress: isCommentOwner == true ? (){
            deleteComment();
            print('owner');
          } : (){print('not owner');          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
              Text(comment),
            ],
          ),
          leading: TextButton(
            onPressed: () => showProfile(context, profileId: currentUser.id),
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

