import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/PostScreen.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed>{

  Widget mediaPreview;
  String activityItemText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, titleText: "Activity Feed"),
        body: Container(
          child: StreamBuilder(
              stream: activityFeedReference.doc(currentUser.id).collection('feedItems').orderBy('timestamp', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: snapshot.data.docs.map((doc) {
                    configureMediaPreview(context, doc['type'], doc['mediaUrl'], doc['commentData'], doc['postId'], doc['ownerId'], );
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: Container(
                        color: Theme.of(context).primaryColorLight,
                        child: ListTile(
                          title: GestureDetector(
                            onTap: () => showProfile(context, profileId: doc['userId']),
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                                children: [
                                  TextSpan(
                                      text: doc['username'],
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                                  TextSpan(text: ' $activityItemText', style: Theme.of(context).textTheme.bodyText1)
                                ],
                              ),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(doc['userProfileImg']),
                          ),
                          subtitle: Text(
                            timeago.format(doc['timestamp'].toDate()),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: mediaPreview,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
          ),
        ));
  }
  configureMediaPreview(context, type, mediaUrl, commentData, postId, userId) {
    if (type == "like" || type == "comment") {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context, postId, userId),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(mediaUrl),
                  )),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = SizedBox();
    }
    if (type == 'like') {
      activityItemText = "liked your post";
    } else if (type == 'follow') {
      activityItemText = "is following you";
    } else if (type == 'comment') {
      activityItemText = "replied: $commentData";
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  showPost(context, postId, userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: postId,
          userId: userId,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage(
            userProfileId: profileId,
          )));
}




