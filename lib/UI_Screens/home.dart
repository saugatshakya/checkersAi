import 'package:cheackers/UI_Screens/chooseAi.dart';
import 'package:cheackers/components/board.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color abButton = Colors.white;
  Color abtxt = Colors.black;
  Color playButton = Colors.white;
  Color playtxt = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Container(
              height: 300,
              child: Column(
                children: [
                  Text(
                    "Checkers",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "The AI Project",
                    style: TextStyle(
                        letterSpacing: 1.75,
                        wordSpacing: 4,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        playButton = Colors.black;
                        playtxt = Colors.white;
                      });
                      Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AiSelection()));
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: playButton),
                      height: 40,
                      width: 120,
                      child: Center(
                          child: Text(
                        "PLAY",
                        style: TextStyle(
                            color: playtxt,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: abButton),
                      height: 40,
                      width: 120,
                      child: Center(
                          child: Text(
                        "ABOUT US",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 32,
              right: 24,
              child: Icon(
                Icons.settings,
                size: 48,
              ))
        ],
      ),
    );
  }
}
