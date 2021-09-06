import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';

class OrganizeForm extends StatefulWidget {

  @override
  _OrganizeFormState createState() => _OrganizeFormState();
}

class _OrganizeFormState extends State<OrganizeForm> {

  bool _isOpen = false;
  bool loading = false;
  useri user;
  String title;
  String location;
  String note = '';
  String name;
  String eventId = Uuid().v4();
  File file;
  String path;
  String imageUrl='https://firebasestorage.googleapis.com/v0/b/petapp-c627e.appspot.com/o/Default%20Pictures%2Fpetprofilepic.jpg?alt=media&token=e02ea3e6-18a4-4b77-b992-efce2e616792';
  bool uploading = false;

  DateTime eventDate = new DateTime.now();
  TimeOfDay eventTime = new TimeOfDay.now();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PanelController _panelController = PanelController();
  TextEditingController usernameTextEditingController = TextEditingController();

  void initState() {
    super.initState();
    getAndDisplayUserInfo();
  }

  getAndDisplayUserInfo() async {
    setState(() {
      loading = true;
    });
    DocumentSnapshot documentSnapshot =
    await usersReference.doc(currentUser.id).get();
    user = useri.fromDocument(documentSnapshot);
    usernameTextEditingController.text = user.username;
    name=user.profileName;
    setState(() {
      loading = false;
    });
  }

  Future<Null> _selectdate(BuildContext context) async{
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: eventDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2023),
        builder: (context,child) {
          return SingleChildScrollView(child: child,);
        }
    );
    final TimeOfDay _seltime = await showTimePicker(
        context: context,
        initialTime: eventTime
    );
    if(_seldate!=null) {
      setState(() {
        eventDate = _seldate;
        print(eventDate);
      });
    }
    if(_seldate==null)
      return;
    if(_seltime!=null) {
      setState(() {
        eventTime = _seltime;
        print(eventTime);
      });
    }
    if(_seltime==null)
      return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {Navigator.pop(context);},
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),),),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: file == null
                      ? AssetImage("assets/images/paw.jpg",)
                      : FileImage(File(file.path)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          /// Sliding Panel
          SlidingUpPanel(
            controller: _panelController,
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.45,
            maxHeight: MediaQuery.of(context).size.height,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
        ],
      ),
    );
  }
  SingleChildScrollView _panelBody(ScrollController controller) {
    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 60,),
            Text('Registration Form',
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 30)),
            TextButton(
              child: Text('Select Cover Photo',
                  style: Theme.of(context).textTheme.bodyText1),
              onPressed: () => _selectPhoto(),
            ),
            SizedBox(height: 30,),
            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text('User Name',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextFormField(
                            enabled: false,
                            controller: usernameTextEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.perm_identity_rounded,
                                color: Colors.pinkAccent,
                              ),
                            ),
                          ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text('Title of the Event',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.event_note_outlined,
                            color: Colors.pinkAccent,
                          ),
                          hintText: "Meetup at Cubbon Park",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "This Field Is Required."),
                          MinLengthValidator(10,
                              errorText: "Minimum 10 Characters Required.")
                        ]),
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text('Location of Event',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.pinkAccent,
                          ),
                          hintText: "Cubbon Park, Bengaluru",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "This Field Is Required."),
                          MinLengthValidator(10,
                              errorText: "Minimum 10 Characters Required.")
                        ]),
                        onChanged: (text) {
                          location = text;
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text('Date and Time Of Event',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextButton(
                        onPressed: (){
                          _selectdate(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.access_time_rounded, color: Colors.pink,),
                            Text('${eventDate.day}/${eventDate.month}/${eventDate.year} ${eventTime.format(context)}', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),),
                            Icon(Icons.calendar_today, color: Colors.pink),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text('Note',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextFormField(
                        validator: MaxLengthValidator(60,
                            errorText: "Maximum 60 Characters Required."),
                        onChanged: (_note) {
                          note = _note;
                        },
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,),
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Only Golden Retrievers .. ",
                          prefixIcon: const Icon(
                            Icons.note,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(top: 29.0, left: 50.0, right: 50.0),
              child: OutlinedButton(
                onPressed: () {
                  if (formKey.currentState != null && formKey.currentState.validate()){
                    setState(() {
                      uploading = true;
                    });
                    _uploadFile();
                  }
                },
                child: Text(
                  "Create Event",
                  style: Theme.of(context).textTheme.bodyText1
                ),
              ),
            ),
            uploading ? linearProgress() : Text(""),
          ],
        ),
      ),
    );
  }

  Future _selectPhoto() async {
    showModalBottomSheet(
      context: context,
      builder: ((builder) => Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Choose Profile photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton.icon(
                    icon: Icon(Icons.camera, color: Colors.pink,),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    label: Text("Camera", style: TextStyle(color: Colors.pink),),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.image, color: Colors.pink,),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    label: Text("Gallery", style: TextStyle(color: Colors.pink),),
                  ),
                ])
          ],
        ),
      )),
    );
  }

  Future _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source,);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        this.file = imageFile;
      });
      setState(() {
        path = imageFile.path;
      });
    }
    return;
  }

  Future _uploadFile() async {
    if(path!=null){
    final ref = peteventstorageReference.child("event_$eventId.jpg");
    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();
    setState(() {
      imageUrl = fileUrl;
    });
  }
    saveEventInfoToFireStore();
  }

  saveEventInfoToFireStore() {
    eventReference.doc(eventId).set({
      'Title': title,
      'Location': location,
      'Date of Event': '${eventDate.day}/${eventDate.month}/${eventDate.year} ${eventTime.format(context)}',
      "ownerId": currentUser.id,
      'url':imageUrl,
      'Note': note,
      'members': {currentUser.id: true},
      'RegistrationDate': DateTime.now(),
      'Owner Name': name,
      'Event ID': eventId,
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Event Created Successfully !'),
      ),
    );
  }

}
