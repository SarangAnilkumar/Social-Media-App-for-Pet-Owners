import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';
import 'package:untitled1/themes/app_color.dart';

class AdoptionCard extends StatefulWidget {

  final String petType;
  final String petBreed;
  final String petBio;
  final String petName;
  final String petGender;
  final String petColor;
  final String petWeight;
  final String petLocation;
  final String owner;
  final String petId;
  final String ownerUrl;
  final NetworkImage image;
  final dynamic members;


  AdoptionCard({@required this.petType, this.petBreed, this.ownerUrl, this.image, this.petBio, this.petLocation, this.owner, this.petId, this.petColor, this.petWeight, this.petName, this.petGender, this.members});

  int getTotalNumberOfMembers(members) {
    if (members == null) {
      return 0;
    }

    int counter = 0;
    members.values.forEach((eachValue) {
      if (eachValue == true) {
        counter += 1;
      }
    });
    return counter;
  }

  @override
  State<AdoptionCard> createState() => _AdoptionCardState(
      memberCount: getTotalNumberOfMembers(this.members),
      members: this.members
  );
}

class _AdoptionCardState extends State<AdoptionCard> {
  final String currentUserId = currentUser.id;
  Map members;
  int memberCount;
  bool _isMember;

  _AdoptionCardState({
    this.memberCount,
    this.members
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    _isMember = (members[currentUserId] == true);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: screenHeight * 0.85,
        width: screenWidth * 0.85,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: screenHeight * 0.35,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[800],width: 1),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: widget.image
                        )
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[900],width: 1),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 10,top: 65, right: 20, left: 20),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 23.0,
                                        backgroundImage: NetworkImage(widget.ownerUrl),
                                      ),
                                      SizedBox(width: 15,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            widget.owner,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6.0,
                                          ),
                                          Text(
                                            'Owner',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(
                                    widget.petBio,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                elevation: 7,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: IconButton(
                                    onPressed: handleMembers,
                                    icon: Icon(
                                      _isMember ? Icons.favorite : Icons.favorite_border,
                                      size: 28.0,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),
                    ],
                  ),

                ],
              ),
              Positioned(
                top: screenHeight * 0.25,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    elevation: 6.0,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                      ),
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.75,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 100,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    widget.petName,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 25,height: 1.5),
                                  ),
                                  widget.petGender == 'Male' ? Icon(Icons.male, color: Colors.blue,) : Icon(Icons.female, color: Colors.pink,),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    widget.petBreed,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5, fontWeight: FontWeight.w500,),

                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),

                              Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.mapMarkerAlt,
                                    size: 15.0,
                                  ),
                                  SizedBox(
                                    width: 6.0,
                                  ),
                                  Expanded(
                                      child: Text(widget.petLocation,
                                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5, fontWeight: FontWeight.w400,),
                                        ),)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );


    /*Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2),)]
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                height: 240,
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                      image: widget.image,
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 18, left: 18, top: 5, bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(widget.petName,maxLines: 3,textAlign: TextAlign.center, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,height: 1.5),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.location_on,size: 17,color: Colors.pink,),
                        SizedBox(width: 15,),
                        Expanded(child: Text(widget.petLocation,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),))
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.people,size: 17,color: Colors.pink,),
                        SizedBox(width: 15,),
                        Text(memberCount > 1 ?'$memberCount Members Interested' : memberCount ==1 ? '$memberCount Member Interested' : '0 Members Interested',style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.account_circle,size: 20,color: Colors.pink,),
                        SizedBox(width: 15,),
                        Text("Contact ", style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),),
                        Text(widget.owner,style: TextStyle(color: Colors.pink,fontSize: 15,height: 1.5, fontWeight: FontWeight.w500)),
                        Text(" for further details ", style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),),
                        // Text("Organized by Laura ",style: contentBlack,)
                      ],
                    ),
                    SizedBox(height: 5,),
                    widget.petBio != '' ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 30),
                        Icon(Icons.note,size: 17,color: Colors.pink,),
                        SizedBox(width: 15,),
                        Text(widget.petBio,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),),
                        SizedBox(height: 5,),
                      ],
                    ) : SizedBox(height: 5,),
                    ElevatedButton(
                      onPressed: handleMembers,
                      style: ElevatedButton.styleFrom(
                        primary: _isMember ? Colors.grey : Colors.pink,
                      ),
                      child: Text(_isMember ? "Joined" : "Join"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );*/
  }

  handleMembers() {
    bool _isMember = members[currentUserId] == true;
    if (_isMember) {
      FirebaseFirestore.instance.collection('adoption').doc(widget.petId).update({'members.$currentUserId': false});
      setState(() {
        memberCount -= 1;
        _isMember = false;
        members[currentUserId] = false;
      });
    } else if (!_isMember) {
      FirebaseFirestore.instance.collection('events').doc(widget.petId).update({'members.$currentUserId': true});
      setState(() {
        memberCount += 1;
        _isMember = true;
        members[currentUserId] = true;
      });
    }
  }


}
