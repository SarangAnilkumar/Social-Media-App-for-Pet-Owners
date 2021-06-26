import 'package:flutter/material.dart';

class PetOptions extends StatelessWidget {
  final String itemOneImg;
  final String itemOneTitle;
  final String itemTwoImg;
  final String itemTwoTitle;
  const PetOptions({
    Key key, this.itemOneImg, this.itemOneTitle, this.itemTwoImg, this.itemTwoTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextButton(
                onPressed: () {Text("");},
                child: Container(
                  width: double.infinity,
                  height: 140,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12,bottom: 15),
                              child: Text(itemOneTitle,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13,height: 1.5)),
                            ),),
                        ),
                      ),
                      Positioned(
                        right: -30,
                        top: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(itemOneImg),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
          SizedBox(width: 10,),
          Flexible(
              child:TextButton(
                onPressed: () {Text("");},
                child: Container(
                  width: double.infinity,
                  height: 140,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12,bottom: 22),
                              child: Text(itemTwoTitle,style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13,height: 1.5),),
                            ),),
                        ),
                      ),
                      Positioned(
                        right: -30,
                        top: 2,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(itemTwoImg),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}