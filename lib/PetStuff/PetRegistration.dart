import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/ProfilePage.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

class PetRegistration extends StatefulWidget {

  String ownerUsername;
  String ownerName;
  String ownerEmail;

  PetRegistration({@required this.ownerUsername, this.ownerName, this.ownerEmail});

  @override
  _PetRegistrationState createState() => _PetRegistrationState();
}

class _PetRegistrationState extends State<PetRegistration> with AutomaticKeepAliveClientMixin<PetRegistration>{

  bool get wantKeepAlive => true;

  TextEditingController locationController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool uploading = false;
  String petName;
  String petBio;
  String petType = 'Dog';
  String petGender;
  String petBreed;
  String downloadUrl;
  int petYr;
  int petMonth;
  int petDay;
  bool pedigree = false;
  bool vaccinated = false;

  File file;
  String petId = Uuid().v4();

  List dogList = ['Labrador Retriever', 'German Shepherd', 'Golden Retriever', 'Beagle', 'Rottweiler', 'Boxer', 'Siberian Husky', 'Shih Tzu'];
  List catList = ["CAT", "CAT1", "CAT2", "CAT3"];

  DateTime petDOB = new DateTime.now();

  Future<Null> _selectdate(BuildContext context) async{
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: petDOB,
        firstDate: DateTime(1971),
        lastDate: DateTime.now(),
        builder: (context,child) {
          return SingleChildScrollView(child: child,);
        }
    );
    if(_seldate!=null) {
      setState(() {
        petDOB = _seldate;
        print(petDOB);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    String _formattedate = new DateFormat.yMd().format(petDOB);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20,top: 80, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Pet Registration", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 30)),
              SizedBox(height: 30,),
              Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    imageProfile(),
                    SizedBox(height: 20,),
                    Text("Select Your Pet"),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LiteRollingSwitch(
                          value: false,
                          textOn: " Cat",
                          textOff: " Dog",
                          colorOn: Colors.pink,
                          colorOff: Colors.pink,
                          iconOn: FontAwesomeIcons.cat,
                          iconOff: FontAwesomeIcons.dog,
                          onChanged: (bool position) {
                            if(position == true){
                              petType = 'Cat';
                              print(petType);
                            }
                            else{
                              petType = 'Dog';
                              print(petType);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Column(
                children: [
                  Text("Select Your Pet's Gender"),
                  SizedBox(height: 10,),
                  LiteRollingSwitch(
                    value: false,
                    textOn: " Female",
                    textOff: " Male",
                    colorOn: Colors.pink,
                    colorOff: Colors.pink,
                    iconOn: Icons.female,
                    iconOff: Icons.male,
                    onChanged: (bool position) {
                      if(position == true){
                        petGender = 'Female';
                        print(petGender);
                      }
                      else{
                        petGender = 'Male';
                        print(petGender);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('Pet Name',
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
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: "This Field Is Required"),
                  ]),
                  onChanged: (_name) {
                    petName = _name;
                  },
                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Your Pet's Name",
                    prefixIcon: const Icon(
                      Icons.pets,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('Pet Breed',
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      isExpanded: true,
                      hint: Text('Pet Breed',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      value: petBreed,
                      onChanged: (value) {
                        setState(() {
                          petBreed = value;
                          print(petBreed);
                        });
                      },
                      items: petType == 'Dog' ? dogList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),);
                      }).toList() : catList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),);
                      }).toList()
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('Date Of Birth',
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
                      Icon(FontAwesomeIcons.birthdayCake, color: Colors.pink,),
                      Text('$_formattedate ', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),),
                      Icon(Icons.calendar_today, color: Colors.pink),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('Pet Bio',
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
                  validator: (_bio) {
                    if (_bio.isEmpty) {
                      return "Can't Be Empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (_bio) {
                    petBio = _bio;
                  },
                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Your Pet's Bio",
                    prefixIcon: const Icon(
                      Icons.note,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('Pet Location',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: ListTile(
                  title: TextFormField(
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,),
                    controller: locationController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_circle, color: Colors.pinkAccent, size: 30,),
                      hintText: "Write the location here....",
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        color: Colors.pink,
                        icon: Icon(Icons.my_location,color: Colors.pink,),
                        onPressed: getUserCurrentLocation,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Pedigree',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    pedigreeSwitch(),
                    Text('Vaccinated',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    vaccinatedSwitch(),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('Owner Details',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: Column(
                  children: [
                    Text("Name : " + widget.ownerName),
                    SizedBox(height: 5,),
                    Text("Username : " + widget.ownerUsername),
                    SizedBox(height: 5,),
                    Text("Email ID : " + widget.ownerEmail)
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: controlUploadAndSave,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    primary: Colors.grey[900],
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(0.0),
                    textStyle: TextStyle(
                      fontSize: 20,),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.pink, Colors.purpleAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Register Pet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              uploading ? linearProgress() : Text(""),
            ],
          ),
        ),
      ),
    );
  }

  getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    //String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.country} - ${mPlaceMark.postalCode}';
    String specificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    locationController.text = specificAddress;
  }

  Widget pedigreeSwitch() {
    return Switch.adaptive(
      activeColor: Colors.pink,
      value: pedigree,
      onChanged: (value) {
        setState(() {
          this.pedigree = value;
        });
        print("Pedigree : " + pedigree.toString());
      },
    );
  }

  Widget vaccinatedSwitch() {
    return Switch.adaptive(
      activeColor: Colors.pink,
      value: vaccinated,
      onChanged: (value) {
        setState(() {
          this.vaccinated = value;
        });
        print("Vaccinated : " + vaccinated.toString());
      },
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 50.0,
          backgroundColor: Colors.grey,
          backgroundImage: file == null
              ? AssetImage("assets/images/paw.jpg",)
              : FileImage(File(file.path)),
        ),
        Positioned(
          bottom: 4.0,
          right: 5.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.pink,
              size: 30.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Pet Profile photo",
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
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  label: Text("Camera", style: TextStyle(color: Colors.pink),),
                ),
                TextButton.icon(
                  icon: Icon(Icons.image, color: Colors.pink,),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  label: Text("Gallery", style: TextStyle(color: Colors.pink),),
                ),
              ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final _picker = ImagePicker();
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    final File imageFile = File(pickedFile.path);
    setState(() {
      this.file = imageFile;
    });

  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressingPhoto();

    downloadUrl = await uploadPhoto(file);

    savePetInfoToFireStore(
      url: downloadUrl,
    );
    locationController.clear();

    setState(() {
      file = null;
      uploading = false;
      petId = Uuid().v4();
    });
    ProfilePage(
      userProfileId:currentUser.id
    );
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$petId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    UploadTask mstorageUploadTask =
    petstorageReference.child("pet_$petId.jpg").putFile(mImageFile);
    TaskSnapshot storageTaskSnapshot = await mstorageUploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  savePetInfoToFireStore({String url, String location, String description}) {
      petReference
          .doc(currentUser.id)
          .collection('Pet')
          .doc(currentUser.id)
          .set({
        'PetType': petType,
        'PetGender': petGender,
        'PetName': petName,
        'PetBreed': petBreed,
        'DOB': petDOB,
        'PetBio': petBio,
        'PetLocation': locationController.text,
        'Pedigree': pedigree,
        'Vaccinated': vaccinated,
        "petId": petId,
        "ownerId": currentUser.id,
        'url':url,
        'RegistrationDate': DateTime.now(),
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pet Registered Successfully !'),
        ),
      );
  }
}
