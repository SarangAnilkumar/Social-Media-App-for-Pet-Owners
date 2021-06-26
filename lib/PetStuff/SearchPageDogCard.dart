import 'package:flutter/material.dart';

class SearchPageDogCard extends StatelessWidget {
  final String imgScr;
  final String title;
  final String location;
  final String members;
  final String orgBy; 
  final String date;
  const SearchPageDogCard({
    Key key, this.imgScr, this.title, this.location, this.members, this.orgBy, this.date
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3),)]
        ),
        child: Container(
            width: 280,
            child: Column(
              children: <Widget>[
                Image.asset(imgScr),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,height: 1.5),),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on,size: 17,),
                          SizedBox(width: 15,),
                          Text(location,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Icon(Icons.people,size: 17,),
                          SizedBox(width: 15,),
                          Text(members,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Icon(Icons.account_circle,size: 20,),
                          SizedBox(width: 15,),
                          RichText(text: 
                          TextSpan(
                            text: "Organized by ",
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),
                            children: <TextSpan>[
                              TextSpan(text: orgBy,style: TextStyle(color: Colors.pink)),
                            ]
                          )
                          )
                          // Text("Organized by Laura ",style: contentBlack,)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Icon(Icons.calendar_today_rounded,size: 17,),
                          SizedBox(width: 15,),
                          Text(date,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15,height: 1.5),)
                        ],
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
}