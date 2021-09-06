import 'package:flutter/material.dart';

class PetProfile extends StatefulWidget {

  String petType;
  String petBio;
  NetworkImage image;

  PetProfile({@required this.petType, this.image, this.petBio});

  @override
  State<PetProfile> createState() => _PetProfileState();
}

class _PetProfileState extends State<PetProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => handleDeletePet(context),
              child: Icon(
                Icons.more_vert,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Hero(
                  tag: "assets/images/Husky.jpg",
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.image,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                widget.petType,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold,
                                    fontSize: 24)
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Bangalore, Karnataka",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [

                        buildPetFeature("3 Years", "Age", context),
                        buildPetFeature("Grey", "Color", context),
                        buildPetFeature("24 Kg", "Weight", context),

                      ],
                    ),
                  ),
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
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildPetFeature(String value, String feature, context){
    return Expanded(
      child: Container(
        height: 70,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400],
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16,
                fontWeight: FontWeight.bold,)
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              feature,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
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
}