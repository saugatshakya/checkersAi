import 'package:cheackers/components/board.dart';
import 'package:flutter/material.dart';

class AiSelection extends StatefulWidget {
  const AiSelection({Key? key}) : super(key: key);

  @override
  _AiSelectionState createState() => _AiSelectionState();
}

class _AiSelectionState extends State<AiSelection> {
  Color abButton = Colors.white;
  Color abtxt = Colors.black;
  Color mm1Button = Colors.white;
  Color mm1txt = Colors.black;
  Color mm2Button = Colors.white;
  Color mm2txt = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              height: 400,
              child: Column(
                children: [
                  Text(
                    "Choose Opponent AI",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        mm1Button = Colors.black;
                        mm1txt = Colors.white;
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Board(
                                      ai: "minmax",
                                      difficulty: 1,
                                    )),
                            (Route<dynamic> route) => false);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: mm1Button),
                      height: 40,
                      width: 200,
                      child: Center(
                          child: Text(
                        "Minmax (Very Easy)",
                        style: TextStyle(
                            color: mm1txt,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        abButton = Colors.black;
                        abtxt = Colors.white;
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Board(
                                      ai: "alphabeta",
                                      difficulty: 3,
                                    )),
                            (Route<dynamic> route) => false);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: abButton),
                      height: 40,
                      width: 200,
                      child: Center(
                          child: Text(
                        "AlphaBeta Pruning (Easy)",
                        style: TextStyle(
                            color: abtxt,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        mm2Button = Colors.black;
                        mm2txt = Colors.white;
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Board(
                                      ai: "minmax",
                                      difficulty: 2,
                                    )),
                            (Route<dynamic> route) => false);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: mm2Button),
                      height: 40,
                      width: 200,
                      child: Center(
                          child: Text(
                        "Minmax (Fair)",
                        style: TextStyle(
                            color: mm2txt,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
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
