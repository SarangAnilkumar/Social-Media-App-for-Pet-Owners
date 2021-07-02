import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PetProfile1 extends StatefulWidget {
  @override
  _PetProfile1State createState() => _PetProfile1State();
}

class _PetProfile1State extends State<PetProfile1> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();

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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/goldenretriever.jpg'),
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

          /// Sliding Panel
          SlidingUpPanel(
            controller: _panelController,
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.35,
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
    double hPadding = 40;
    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 40,),
                _titleSection(),
                SizedBox(height: 40,),
                _infoSection(),
                SizedBox(height: 40,),
                _actionSection(),
                SizedBox(height: 60,),
                OutlinedButton(
                    onPressed: () {print('Edit Pet Profile Page');},
                    child: Text("Edit Pet Profile",  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15)))
              ],
            ),
          ),

        ],
      ),
    );
  }

   _actionSection() {
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
              "The Golden Retriever is a medium-large gun dog that was bred to retrieve shot waterfowl, such as ducks and upland game birds, during hunting and shooting parties. The name 'retriever' refers to the breed's ability to retrieve shot game undamaged due to their soft mouth.",
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14,),
                textAlign: TextAlign.center,

            ),
          ),
        ],
      ),
    );
  }

  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _infoCell(title: 'Age', value: '3 Years'),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Color', value: "Golden"),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Weight', value: '24 Kg'),
      ],
    );
  }

  Column _infoCell({String title, String value}) {
    return Column(
      children: <Widget>[
        Text(
            title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500,
              fontSize: 14, color: Colors.pink)
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Column _titleSection() {
    return Column(
      children: <Widget>[
        Text(
          'Bruno',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Golden Retriever',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
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
