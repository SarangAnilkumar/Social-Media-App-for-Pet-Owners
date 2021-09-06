import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:untitled1/models/user.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget {
  final useri currentUser;
  UploadPage({this.currentUser});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  File file;
  bool uploading = false;
  useri user;
  String type;
  final _picker = ImagePicker();
  bool loading = false;
  String postId = Uuid().v4();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  captureImageWithCamera() async {
    Navigator.pop(context);
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    final File imageFile = File(pickedFile.path);
    setState(() {
      this.file = imageFile;
      type = 'Image';
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    final File imageFile = File(pickedFile.path);
    setState(() {
      this.file = imageFile;
      type = 'Image';
    });
  }

  takeImage(mcontext) {
    return showDialog(
        context: mcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text("New Post",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Capture Image with Camera",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 15),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 15),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 15),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  displayUploadScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Row(
                children: [
                  TextButton.icon(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      label: Text(""))
                ],
              ),
              SizedBox(height: 120),
              Icon(
                Icons.add_photo_alternate,
                color: Colors.grey,
                size: 100.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  child: Text(
                    "Upload Image",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => takeImage(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  clearPostInfo() {
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
    });
  }

  getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddressInfo =
        '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country},';
    String specificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    locationTextEditingController.text = specificAddress;
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile));
    setState(() {
      file = compressedImageFile;
    });
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressingPhoto();

    String downloadUrl = await uploadPhoto(file);

    savePostInfoToFireStore(
        url: downloadUrl,
        location: locationTextEditingController.text,
        description: descriptionTextEditingController.text);

    locationTextEditingController.clear();
    descriptionTextEditingController.clear();

    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home()));
  }

  getAndDisplayUserInfo() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot =
    await usersReference.doc(currentUser.id).get();
    user = useri.fromDocument(documentSnapshot);

    setState(() {
      loading = false;
    });
  }

  savePostInfoToFireStore({String url, String location, String description}) {
    postsReference
        .doc(currentUser.id)
        .collection("usersPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": currentUser.id,
      "timestamp": timestamp,
      "likes": {},
      "username": currentUser.username,
      "description": description,
      "location": location,
      "url": url,
    });
    timelineReference.doc(postId).set({
      "postId": postId,
      "ownerId": currentUser.id,
      "timestamp": timestamp,
      "likes": {},
      "username": currentUser.username,
      "description": description,
      "location": location,
      "url": url,
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    UploadTask mstorageUploadTask =
    storageReference.child("post_$postId.jpg").putFile(mImageFile);
    TaskSnapshot storageTaskSnapshot = await mstorageUploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Scaffold displayUploadFormScreen() {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: clearPostInfo,
          ),
          title: Text(
            "New Post",
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: uploading ? null : () => controlUploadAndSave(),
              child: Text(
                "Share",
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              uploading ? linearProgress() : Text(""),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width*0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                  CachedNetworkImageProvider(currentUser.url),
                ),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 15,
                    ),
                    controller: descriptionTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Write a caption..",
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(
                  Icons.person_pin_circle,
                  color: Colors.pinkAccent,
                  size: 37.0,
                ),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 15,
                    ),
                    controller: locationTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Write the location here....",
                      hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                  ),
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Get my Current Location",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: getUserCurrentLocation,
                ),
              ),
            ],
          ),
        )
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}