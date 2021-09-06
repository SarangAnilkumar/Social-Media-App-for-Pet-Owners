import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:untitled1/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';

class PetRegistration extends StatefulWidget {

  final String ownerUsername;
  final String ownerName;
  final String ownerEmail;


  PetRegistration({@required this.ownerUsername, this.ownerName, this.ownerEmail});

  @override
  _PetRegistrationState createState() => _PetRegistrationState();
}

class _PetRegistrationState extends State<PetRegistration>{


  TextEditingController locationController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool uploading = false;
  String petName;
  String petBio='';
  String petType = 'Dog';
  String petGender;
  String petBreed;
  String path;
  String petWeight;
  String imageUrl='https://firebasestorage.googleapis.com/v0/b/petapp-c627e.appspot.com/o/Default%20Pictures%2Fpetprofilepic.jpg?alt=media&token=e02ea3e6-18a4-4b77-b992-efce2e616792';
  String petColor;
  int petYr;
  int petMonth;
  int petDay;
  bool pedigree = false;
  bool vaccinated = false;

  File file;
  String petId = Uuid().v4();

  List <String> dogList = ['Akita','American Pit Bull Terrier','Beagle','Boxer','Bull Terrier','Bulldog','Chihuahua',
    'Chow-Chow','Cocker Spaniel','Dalmatian','Dobermann','German Shepherd','Golden Retriever','Great Dane','Labrador Retriever',
    'Pomeranian','Poodle','Pug','Rottweiler','Samoyed','Shiba Inu','Shih Tzu','Siberian Husky','St. Bernard'];
  List catList = ['Abyssinian','American Bobtail','American Curl','American Shorthairs','Bengal Cat','Birman',
    'Bombay Cat','British Shorthairs','Devon Rex','Himalayan Cat','Maine Coon','Munchkin','Oriental Shorthairs',
    'Persian Cat', 'Ragdoll','Scottish fold','Siamese','Singapura','Somali','Spotted Cat'];

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
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20,top: 80, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Pet Registration", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 30)),
              SizedBox(height: 45,),
              userImage(),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Text("Select Your Pet",  style: Theme.of(context).textTheme.bodyText1),
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
                      SizedBox(height: 20,),
                      Column(
                        children: [
                          Text("Select Your Pet's Gender",  style: Theme.of(context).textTheme.bodyText1),
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
                      SizedBox(height: 20,),
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
                          validator: RequiredValidator(
                                errorText: "This Field Is Required"),
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
                              Text('${petDOB.day}/${petDOB.month}/${petDOB.year}', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),),
                              Icon(Icons.calendar_today, color: Colors.pink),
                            ],
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
                          child: DropdownButtonFormField(
                            validator: (value) => value == null ? "This Field Is Required" : null,
                              isExpanded: true,
                              hint: Text('Select your Pet Breed',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              value: petBreed,
                              onChanged: (value) {
                                setState(() {
                                  petBreed = value;
                                  print(petBreed);
                                });
                              },
                              items: petType == 'Dog'
                                  ?dogList.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),);
                              }).toList()
                                  :catList.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),);
                              }).toList()
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                child: Text('Pet Color',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                width: 160,
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "This Field Is Required"),
                                  ]),
                                  onChanged: (_color) {
                                    petColor = _color;
                                  },
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Color",
                                    prefixIcon: const Icon(
                                      Icons.invert_colors_rounded,
                                      color: Colors.pinkAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text('Pet Weight',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                width: 160,
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "This Field Is Required"),
                                  ]),
                                  onChanged: (_kg) {
                                    petWeight = _kg;
                                  },
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "In Kg",
                                    prefixIcon: const Icon(
                                      Icons.shopping_bag,
                                      color: Colors.pinkAccent,
                                    ),
                                    suffixText: 'Kgs    '
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                            validator: RequiredValidator(
                                errorText: "This Field Is Required."),
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
                          onPressed: () {
                            if (formkey.currentState != null && formkey.currentState.validate()){
                              setState(() {
                                uploading = true;
                              });
                              _uploadFile();
                            }
                          },
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
    String specificAddress = '${mPlaceMark.subLocality}, ${mPlaceMark.locality}, ${mPlaceMark.administrativeArea}, ${mPlaceMark.country}- ${mPlaceMark.postalCode}';
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

  userImage(){
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 55.0,
            backgroundColor: Colors.black,
            backgroundImage: file == null
                ? AssetImage("assets/images/paw.jpg",)
                : FileImage(File(file.path)),
          ),

          InkWell(
            onTap: () => _selectPhoto(),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Select Photo',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          )
        ],
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
      final ref = petstorageReference.child("pet_$petId.jpg");
      final result = await ref.putFile(File(path));
      final fileUrl = await result.ref.getDownloadURL();

      setState(() {
        imageUrl = fileUrl;
      });
    }
    await petBioInfo();
    savePetInfoToFireStore();
  }

  savePetInfoToFireStore() {
    petReference
        .doc(currentUser.id)
        .collection('Pet').add({
      'PetType': petType,
      'PetGender': petGender,
      'PetName': petName,
      'PetBreed': petBreed,
      'DOB': petDOB,
      'PetBio': petBio,
      'PetLocation': locationController.text,
      'Pedigree': pedigree,
      'Vaccinated': vaccinated,
      "PetId": petId,
      "PetColor": petColor,
      "PetWeight" : petWeight,
      "ownerId": currentUser.id,
      'url':imageUrl,
      'Interests': [],
      'RegistrationDate': DateTime.now(),
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pet Registered Successfully !'),
      ),
    );
  }

  petBioInfo(){
    if(petBio==''){
      if(petType == 'Dog')
        {
          if(petBreed == 'Akita')
            petBio = 'The Akita is a large breed of dog originating from the mountainous regions of northern Japan. The Akita is a powerful, independent and dominant breed, commonly aloof with strangers but affectionate with family members.';
          else if(petBreed == 'American Pit Bull Terrier')
            petBio = 'American Pit Bull Terrier is a medium-sized, intelligent, short-haired dog, of a solid build, whose early ancestors came from the British Isles. ';
          else if(petBreed == 'Beagle')
            petBio = 'The beagle is a breed of small scent hound, similar in appearance to the much larger foxhound. The beagle was developed primarily for hunting hare.  It is a popular pet due to its size, good temper, and a lack of inherited health problems.';
          else if(petBreed == 'Boxer')
            petBio = 'The Boxer is a medium to large, short-haired breed of dog, developed in Germany. The coat is smooth and tight-fitting; colors are fawn, brindled, or white, with or without white markings. ';
          else if(petBreed == 'Bull Terrier')
            petBio = 'The Bull Terrier is a breed of dog in the terrier family. A Bull Terrier has an even temperament and is amenable to discipline.';
          else if(petBreed == 'Bulldog')
            petBio = 'The Bulldog, also known as the English Bulldog or British Bulldog, is a medium-sized dog breed. It is a muscular, hefty dog with a wrinkled face and a distinctive pushed-in nose. ';
          else if(petBreed == 'Chihuahua')
            petBio = 'The Chihuahua is one of the smallest breeds of dog, and is named after the Mexican state of Chihuahua. ';
          else if(petBreed == 'Chow-Chow')
            petBio = 'The Chow Chow is a dog breed originally from northern China. The Chow Chow is a sturdily built dog, square in profile, with a broad skull and small, triangular, erect ears with rounded tips. The breed is known for a very dense double coat that is either smooth or rough.';
          else if(petBreed == 'Cocker Spaniel')
            petBio = 'The Cocker Spaniel is a breed of gun dog. It is noteworthy for producing one of the most varied numbers of pups in a litter among all dog breeds. The Cocker Spaniel is an active, good-natured, sporting dog standing well up at the withers and compactly built.';
          else if(petBreed == 'Dalmatian')
            petBio = 'The Dalmatian is a breed of medium-sized dog, noted for its unique white coat marked with black or brown-colored spots. Originating as a hunting dog, it was also used as a carriage dog in its early days. The origins of this breed can be traced back to present-day Croatia and its historical region of Dalmatia.';
          else if(petBreed == 'Dobermann')
            petBio = 'The Dobermann, or Doberman Pinscher in the United States and Canada, is a medium-large breed of domestic dog that was originally developed around 1890 by Karl Friedrich Louis Dobermann, a tax collector from Germany. The Dobermann has a long muzzle. It stands on its pads and is not usually heavy-footed.';
          else if(petBreed == 'German Shepherd')
            petBio = 'The German Shepherd is a breed of medium to large-sized working dog that originated in Germany. Shepherds are working dogs developed originally for herding sheep.';
          else if(petBreed == 'Golden Retriever')
            petBio = "The Golden Retriever is a medium-large gun dog that was bred to retrieve shot waterfowl, such as ducks and upland game birds, during hunting and shooting parties. The name 'retriever' refers to the breed's ability to retrieve shot game undamaged due to their soft mouth.";
          else if(petBreed == 'Great Dane')
            petBio = 'The Great Dane, also known as the German Mastiff or Deutsche Dogge, is a breed of dog from Germany. The Great Dane descends from hunting dogs known from the Middle Ages and is one of the largest breeds in the world.';
          else if(petBreed == 'Labrador Retriever')
            petBio = 'The Labrador Retriever, often abbreviated to Labrador or Lab, is a breed of retriever-gun dog from the United Kingdom that was developed from imported Canadian fishing dogs. The Labrador is one of the most popular dog breeds in a number of countries in the world, particularly in the Western world.';
          else if(petBreed == 'Pomeranian')
            petBio = 'The Pomeranian is a breed of dog of the Spitz type that is named for the Pomerania region in north-west Poland and north-east Germany in Central Europe. Classed as a toy dog breed because of its small size, the Pomeranian is descended from larger Spitz-type dogs, specifically the German Spitz.';
          else if(petBreed == 'Poodle')
            petBio = 'The Poodle, called the Pudel in German and the Caniche in French, is a breed of water dog.';
          else if(petBreed == 'Pug')
            petBio = 'The pug is a breed of dog with physically distinctive features of a wrinkly, short-muzzled face, and curled tail. The breed has a fine, glossy coat that comes in a variety of colors, most often light brown or black, and a compact, square body with well-developed muscles.';
          else if(petBreed == 'Rottweiler')
            petBio = "The Rottweiler is a breed of domestic dog, regarded as medium-to-large or large. The dogs were known in German as Rottweiler Metzgerhund, meaning Rottweil butchers' dogs, because their main use was to herd livestock and pull carts laden with butchered meat to market.";
          else if(petBreed == 'Samoyed')
            petBio = 'The Samoyed is a breed of medium-sized herding dogs with thick, white, double-layer coats. They are related to the laika, a spitz-type dog. It takes its name from the Samoyedic peoples of Siberia. These nomadic reindeer herders bred the fluffy white dogs to help with herding.';
          else if(petBreed == 'Shiba Inu')
            petBio = 'The Shiba Inu is a breed of hunting dog from Japan. A small-to-medium breed, it is the smallest of the six original and distinct spitz breeds of dog native to Japan. A small, alert, and agile dog that copes very well with mountainous terrain and hiking trails, the Shiba Inu was originally bred for hunting.';
          else if(petBreed == 'Shih Tzu')
            petBio = 'The Shih Tzu is an Asian toy dog breed originating from Tibet. This breed is well-known for their short snout and large round eyes, as well as their ever growing coat, floppy ears, and short and stout posture. Although small in size, they are notorious for their largely fun and playful personality, and calm and friendly temperament.';
          else if(petBreed == 'Siberian Husky')
            petBio = 'The Siberian Husky is a medium-sized working sled dog breed. The breed belongs to the Spitz genetic family. It is recognizable by its thickly furred double coat, erect triangular ears, and distinctive markings, and is smaller than the similar-looking Alaskan Malamute.';
          else if(petBreed == 'St. Bernard')
            petBio = 'The Saint Bernard or St. Bernard is a breed of very large working dog from the Western Alps in Italy and Switzerland. They were originally bred for rescue work by the hospice of the Great St Bernard Pass on the Italian-Swiss border.';
          else
            return;
        }
      else
        {
          if(petBreed == 'Abyssinian')
            petBio = 'The Abyssinian is a breed of domestic short-haired cat with a distinctive "ticked" tabby coat, in which individual hairs are banded with different colors. In nomenclature terms, they are also known as simply Abys. The breed is named for Abyssinia, where it is believed to have originated.';
          else if(petBreed == 'American Bobtail')
            petBio = "The American Bobtail is an uncommon breed of domestic cat which was developed in the late 1960s. It is most notable for its stubby 'bobbed' tail about one-third to one-half the length of a normal cat's tail.";
          else if(petBreed == 'American Curl')
            petBio = "The American Curl is a breed of cat characterized by its unusual ears, which curl back from the face toward the center of the back of the skull. An American Curl's ears should be handled carefully because rough handling may damage the cartilage in the ear.";
          else if(petBreed == 'American Shorthairs')
            petBio = 'The American Shorthair is a breed of domestic cat believed to be descended from European cats brought to North America by early settlers to protect valuable cargo from mice and rats.';
          else if(petBreed == 'Bengal Cat')
            petBio = "The Bengal cat is a domesticated cat breed created from hybrids of domestic cats, especially the spotted Egyptian Mau, with the Asian leopard cat. The breed name comes from the leopard cat's taxonomic name.";
          else if(petBreed == 'Birman')
            petBio = 'The Birman, also called the "Sacred Cat of Burma", is a domestic cat breed. The Birman is a long-haired, colour-pointed cat distinguished by a silky coat, deep blue eyes, and contrasting white "gloves" on each paw. The breed name is derived from Birmanie, the French form of Burma.';
          else if(petBreed == 'Bombay Cat')
            petBio = 'The Bombay cat is a type of short-haired cat developed by breeding sable Burmese and black American Shorthair cats, to produce a cat of mostly Burmese type, but with a sleek, panther-like black coat. Bombay is the name given to black cats of the Asian group.';
          else if(petBreed == 'British Shorthair')
            petBio = 'The British Shorthair is the pedigreed version of the traditional British domestic cat, with a distinctively stocky body, dense coat, and broad face. The most familiar colour variant is the "British Blue", with a solid grey-blue coat, orange eyes, and a medium-sized tail.';
          else if(petBreed == 'Devon Rex')
            petBio = 'The Devon Rex is a breed of intelligent, tall-eared, short-haired cat that emerged in England during the late 1950s. They are known for their slender bodies, wavy coat, and large ears. This breed of cat is capable of learning difficult tricks but can be hard to motivate.';
          else if(petBreed == 'Himalayan Cat')
            petBio = 'The Himalayan, is a breed or sub-breed of long-haired cat similar in type to the Persian, with the exception of its blue eyes and its point colouration, which were derived from crossing the Persian with the Siamese.';
          else if(petBreed == 'Maine Coon')
            petBio = 'The Maine Coon is a large domesticated cat breed. It has a distinctive physical appearance and valuable hunting skills. It is one of the oldest natural breeds in North America, specifically native to the US state of Maine, where it is the official state cat.';
          else if(petBreed == 'Munchkin Cat')
            petBio = 'The Munchkin cat or Sausage cat is a relatively new breed of cat characterized by its very short legs, which are caused by genetic mutation. The Munchkin is considered to be the original breed of dwarf cat.';
          else if(petBreed == 'Oriental Shorthairs')
            petBio = 'The Oriental Shorthair is a breed of domestic cat that is developed from and closely related to the Siamese cat. It maintains the modern Siamese head and body type but appears in a wide range of coat colors and patterns.';
          else if(petBreed == 'Persian Cat')
            petBio = 'The Persian cat is a long-haired breed of cat characterized by its round face and short muzzle. It is also known as the "Persian Longhair" in the English-speaking countries. The first documented ancestors of the Persian were imported into Italy from Persia around 1620.';
          else if(petBreed == 'Ragdoll')
            petBio = 'The Ragdoll is a cat breed with a color point coat and striking blue eyes. Their form is large and muscular and their coat is silky soft and semi-longhair. Ragdolls were developed by American breeder Ann Baker in the 1960s. They are best known for their docile and placid temperament and affectionate nature.';
          else if(petBreed == 'Scottish fold')
            petBio = 'The Scottish Fold is a breed of domestic cat with a natural dominant-gene mutation that affects cartilage throughout the body, causing the ears to "fold", bending forward and down towards the front of the head, which gives the cat what is often described as an "owl-like" appearance. ';
          else if(petBreed == 'Siamese Cat')
            petBio = 'The Siamese cat is one of the first distinctly recognized breeds of Asian cat. Derived from the Wichianmat landrace, one of several varieties of cat native to Thailand, the original Siamese became one of the most popular breeds in Europe and North America in the 19th century.';
          else if(petBreed == 'Singapura Cat')
            petBio = 'The Singapura is the smallest breed of cat, noted for its large eyes and ears, ticked coat, and blunt tail. Reportedly established from three "drain cats" imported from Singapore in the 1970s, it was later revealed that the cats were originally sent to Singapore from the US before they were exported back to the US.';
          else if(petBreed == 'Somali Cat')
            petBio = 'The Somali cat is often described as a long-haired African cat, a product of a recessive gene in Abyssinian cats, though how the gene was introduced into the Abyssinian gene pool is unknown. It is believed that they originated from Somalia, a long lost cousin of the Abyssinian cat, which has origins in Ethiopia.';
          else if(petBreed == 'Spotted Cat')
            petBio = "The rusty-spotted cat is one of the cat family's smallest members, of which historical records are known only from India and Sri Lanka. In 2012, it was also recorded in the western Terai of Nepal.";
          else
            return;
        }
    }
  }
}
