import 'package:cheackers/UI_Screens/home.dart';
import 'package:cheackers/components/board.dart';
import 'package:flutter/material.dart';

class Pause extends StatefulWidget {
  const Pause({Key? key}) : super(key: key);

  @override
  _PauseState createState() => _PauseState();
}

class _PauseState extends State<Pause> {
  Color abButton = Colors.white;
  Color abtxt = Colors.black;
  Color mm1Button = Colors.white;
  Color mm1txt = Colors.black;
  Color mm2Button = Colors.white;
  Color mm2txt = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 400,
          child: Column(
            children: [
              Text(
                "Paused",
                style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
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
                    Navigator.pop(
                      context,
                    );
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
                    "Resume",
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
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Board(
                                  ai: "alphabeta",
                                  difficulty: 3,
                                )));
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), color: abButton),
                  height: 40,
                  width: 200,
                  child: Center(
                      child: Text(
                    "Setting",
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
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
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
                    "Main Menu",
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
    );
  }
}
