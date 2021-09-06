import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';

class PetProfile1 extends StatefulWidget {
  final String petType;
  final String petBreed;
  final String petBio;
  final String petName;
  final String petGender;
  final String petColor;
  final String petWeight;
  final String PetId;
  final String UserId;
  final String petLocation;
  final NetworkImage image;
  final Timestamp petDOB;
  final bool pedigree;
  final bool vaccinated;

  PetProfile1({@required this.petType,this.PetId,this.UserId, this.petBreed, this.image, this.petBio, this.petDOB, this.petLocation, this.petColor, this.petWeight, this.petName, this.pedigree, this.vaccinated, this.petGender});


  @override
  _PetProfile1State createState() => _PetProfile1State(
    petDOB : this.petDOB.toDate(),

  );
}

class _PetProfile1State extends State<PetProfile1> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();
  int petYr;
  int petMonth;
  int petDay;
  String PetID;
  DateTime petDOB;
  _PetProfile1State({
    this.petDOB,
    this.PetID,
  });


  void initState() {
    super.initState();
    getInfo();
  }

  getInfo(){
    petYr=DateTime.now().year-petDOB.year;
    petMonth=DateTime.now().month-petDOB.month;
    petDay=DateTime.now().day-petDOB.day;
    if(petDay<0){
      petMonth=petMonth-1;
      if(petMonth<0) {
        petYr=petYr-1;
        petMonth=12+petMonth;
      }}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.pink,
          ),
        ),
        actions: [
          currentUser.id == widget.UserId ?
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => handleDeletePet(context),
              child: Icon(
                Icons.more_vert,
                color: Colors.pink,
              ),
            ),
          ) : Padding(
            padding: EdgeInsets.only(right: 16),

          )
        ] ,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.39,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
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
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40,),
                titleSection(),
                SizedBox(height: 40,),
                infoSection(),
                SizedBox(height: 30,),
                pedigree(),
                SizedBox(height: 40,),
                petStorySection(),
                SizedBox(height: 40,),
                OutlinedButton(
                    onPressed: () {
                      print('Edit Pet Profile Page');
                      print(petYr);
                      print(widget.petDOB.toString());},
                    child: Text("Edit Pet Profile",  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15)))
              ],
            ),
          ),

        ],
      ),
    );
  }

  petStorySection() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                "Pet Story",
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold,fontSize: 24)
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.petBio,
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16,),
                textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              alignment: Alignment.center,
              width: 200,
              child: Text(widget.petLocation, style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,),textAlign: TextAlign.center,)
          ),
        ],
      ),
    );
  }

  pedigree() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pedigree : ', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 17)),
            widget.pedigree == true ? Icon(Icons.check, color: Colors.green,) : Icon(Icons.clear, color: Colors.red),
            SizedBox(width: 40,),
            Text('Vaccinated : ', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 17)),
            widget.vaccinated == true ? Icon(Icons.check, color: Colors.green) : Icon(Icons.clear, color: Colors.red),
          ],
        ),
      ],
    );
  }

  Row infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _infoCell(
            title: 'Age',
            value: petYr > 1 ? '  $petYr Years \n$petMonth Months' : petYr ==1 ? '  $petYr Year \n$petMonth Months' :
            petMonth>1 ? '$petMonth Months' : petMonth ==1 ? '$petMonth Month' : petDay>1 ? '$petDay Days' : petDay==1 ? '$petDay Day': '-'
        ),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Color', value: widget.petColor),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Weight', value: widget.petWeight + " Kg"),
      ],
    );
  }

  Column _infoCell({String title, String value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
            title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500,
              fontSize: 17, color: Colors.pink)
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Column titleSection() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.petName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
            ),
            SizedBox(width: 5,),
            widget.petGender == 'Male' ? Icon(Icons.male, color: Colors.blue,) : Icon(Icons.female, color: Colors.pink,),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          widget.petBreed,
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontStyle: FontStyle.italic, fontSize: 17)
        ),
        SizedBox(
          height: 5,
        ),
        Text(
            widget.petType,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontStyle: FontStyle.italic, fontSize: 15)
        ),
      ],
    );
  }

  handleDeletePet(BuildContext mcontext){
    return showDialog(
        context: mcontext,
        builder: (context) {
          return SimpleDialog(title: Text("Remove this pet ?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  deletePet();
                  Navigator.pop(context);
                  print("Pet Deleted");
                  Navigator.pop(context);
                  //deletePost();
                },
                child: Text('Remove Pet',
                  style: TextStyle(color: Colors.red),),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }
  deletePet() async {
    FirebaseStorage.instance.ref().child('Pet Pictures').child("pet_$PetID.jpg").delete();
    QuerySnapshot petSnapshot = await FirebaseFirestore.instance.collection('Pets').doc(widget.UserId).collection('Pet')
        .where('PetId', isEqualTo: widget.PetId)
        .get();
    petSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    QuerySnapshot tinderSnapshot = await FirebaseFirestore.instance.collection('Tinder').where('PetId', isEqualTo: widget.PetId)
        .get();
    tinderSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

}
