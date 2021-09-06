import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled1/pages/Home.dart';
import 'package:untitled1/pages/Login.dart';

class PetEventCard extends StatefulWidget {

  final String location;
  final String Title;
  final String name;
  final String url;
  final String EventID;
  final String date;
  final String note;
  final dynamic members;
  final String ownerId;

  PetEventCard({
    @required this.location, this.EventID, this.ownerId, this.date, this.note, this.Title, this.name, this.url, this.members
  });

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
  State<PetEventCard> createState() => _PetEventCardState(
      memberCount: getTotalNumberOfMembers(this.members),
      members: this.members
  );
}

class _PetEventCardState extends State<PetEventCard> {
  final String currentUserId = currentUser.id;

  Map members;
  int memberCount;
  DateTime date;
  bool _isMember;


  _PetEventCardState({
    this.memberCount,
    this.members
});


  @override
  Widget build(BuildContext context) {
    _isMember = (members[currentUserId] == true);
    bool isPostOwner = currentUserId == widget.ownerId;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3),)]
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                height: screenHeight*0.3,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        image: NetworkImage(widget.url)
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 18, left: 18, top: 5, bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(widget.Title,maxLines: 3,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, height: 1.5),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.location_on,size: 17,color: Colors.pink,),
                          SizedBox(width: 15,),
                          Expanded(child: Text(widget.location,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),))
                        ],
                      ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.people,size: 17,color: Colors.pink,),
                        SizedBox(width: 15,),
                        Text(memberCount > 1 ?'$memberCount Members' : memberCount ==1 ? '$memberCount Member' : '0 Members',style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.account_circle,size: 20,color: Colors.pink,),
                        SizedBox(width: 15,),
                        Text("Organized by ",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),),
                        Text(widget.name,style: TextStyle(color: Colors.pink,fontSize: 15,height: 1.5, fontWeight: FontWeight.w500)),
                        isPostOwner
                            ? IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                          ),
                          onPressed: () => handleDeletePost(context),
                        )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.calendar_today_rounded,size: 17,color: Colors.pink,),
                        SizedBox(width: 15,),
                        Text(widget.date,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),)
                      ],
                    ),
                    widget.note != '' ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 30),
                        Icon(Icons.note,size: 17,color: Colors.pink,),
                        SizedBox(width: 15,),
                        Expanded(child: Text(widget.note,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),)),
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
    );
  }

  handleDeletePost(BuildContext mcontext) {
    return showDialog(
        context: mcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this Event ?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deletePost();
                },
                child: Text(
                  'Delete Event',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  deletePost() async {
    FirebaseFirestore.instance.collection('events').doc(widget.EventID).get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    peteventstorageReference.child("event_${widget.EventID}.jpg").delete();
  }


  handleMembers() {
    bool _isMember = members[currentUserId] == true;
    if (_isMember) {
      FirebaseFirestore.instance.collection('events').doc(widget.EventID).update({'members.$currentUserId': false});
      setState(() {
        memberCount -= 1;
        _isMember = false;
        members[currentUserId] = false;
      });
    } else if (!_isMember) {
      FirebaseFirestore.instance.collection('events').doc(widget.EventID).update({'members.$currentUserId': true});
      setState(() {
        memberCount += 1;
        _isMember = true;
        members[currentUserId] = true;
      });
    }
  }

}
