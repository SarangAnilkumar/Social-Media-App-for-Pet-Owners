import 'package:flutter/material.dart';
import 'package:untitled1/PAGETEST/TestPostWidget.dart';
import 'package:untitled1/pages/PostScreen.dart';
import 'package:untitled1/widgets/CImageWidget.dart';

class TestPostTile extends StatelessWidget {
  final TestPost post;

  TestPostTile(this.post);

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: post.postId,
          userId: post.ownerId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: cachedNetworkImage(post.url),
    );
  }
}
