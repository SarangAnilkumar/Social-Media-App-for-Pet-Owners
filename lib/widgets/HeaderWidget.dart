import 'package:flutter/material.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/pages/UploadPage.dart';

AppBar header(context,
    {bool isAppTitle = false,
    String titleText,
    disappearedBackButton = false}) {
  return AppBar(
    leading: isAppTitle
        ? IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadPage(
                            currentUser: currentUser,
                          )));
            },
          )
        : null,
    iconTheme: IconThemeData(
      color: Colors.pink,
    ),
    automaticallyImplyLeading: disappearedBackButton ? true : false,
    title: Text(
      isAppTitle ? "PetApp" : titleText,
      style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: isAppTitle ? 45.0 : 22.0,
            fontFamily: isAppTitle ? "Signatra" : "",
          ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColorLight,
  );
}
