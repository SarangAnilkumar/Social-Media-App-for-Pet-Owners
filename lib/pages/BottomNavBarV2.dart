import 'package:flutter/material.dart';
import 'package:untitled1/pages/MyHomePage.dart';

class BottomNavBarV2 extends StatefulWidget {
  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: Stack(
                      children: <Widget>[
                        Transform.translate(
                          offset: Offset.fromDirection(getRadiansFromDegree(315),degOneTranslationAnimation.value * 80),
                          child: Transform(
                            transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degOneTranslationAnimation.value),
                            alignment: Alignment.center,
                            child: CircularButton(
                              color: Colors.pink,
                              width: 50,
                              height: 50,
                              icon: Icon(
                                Icons.pets_rounded,
                                color: Colors.white,
                              ),
                              onClick: (){
                                print('First Button');
                              },
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(getRadiansFromDegree(270),degTwoTranslationAnimation.value * 80),
                          child: Transform(
                            transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degTwoTranslationAnimation.value),
                            alignment: Alignment.center,
                            child: CircularButton(
                              color: Colors.pink,
                              width: 50,
                              height: 50,
                              icon: Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                              ),
                              onClick: (){
                                print('Second button');
                              },
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(getRadiansFromDegree(225),degThreeTranslationAnimation.value * 80),
                          child: Transform(
                            transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degThreeTranslationAnimation.value),
                            alignment: Alignment.center,
                            child: CircularButton(
                              color: Colors.pink,
                              width: 50,
                              height: 50,
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                              ),
                              onClick: (){
                                print('Third Button');
                              },
                            ),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value)),
                          alignment: Alignment.center,
                          child: CircularButton(
                            color: Colors.pink,
                            width: 60,
                            height: 60,
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            onClick: (){
                              if (animationController.isCompleted) {
                                animationController.reverse();
                              } else {
                                animationController.forward();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 0 ? Colors.pink : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.search,
                              color: currentIndex == 1 ? Colors.pink : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(1);
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: currentIndex == 2 ? Colors.pink : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.person,
                              color: currentIndex == 3 ? Colors.pink : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(3);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2,end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4,end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75,end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0,end: 0.0).animate(CurvedAnimation(parent: animationController
        , curve: Curves.easeOut));
    super.initState();
    animationController.addListener((){
      setState(() {

      });
    });
  }

  AnimationController animationController;
  Animation degOneTranslationAnimation,degTwoTranslationAnimation,degThreeTranslationAnimation;
  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}