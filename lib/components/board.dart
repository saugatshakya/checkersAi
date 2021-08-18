import 'dart:convert';
import 'package:cheackers/UI_Screens/pauseScreen.dart';
import 'package:cheackers/components/piece.dart';
import 'package:flutter/material.dart';
import 'package:collection/equality.dart';
import 'package:http/http.dart' as http;

class Board extends StatefulWidget {
  final int difficulty;
  final String ai;
  Board({required this.difficulty, required this.ai});
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Map white = {"player": 1, "king": false};
  Map black = {"player": 2, "king": false};
  Map whiteKing = {"player": 1, "king": true};
  Map blackKing = {"player": 2, "king": true};
  Map empty = {"player": 0, "king": false};
  late List currentState;
  late List initialState;
  List validmove1 = [9, 9];
  List validmove2 = [9, 9];
  List validmove3 = [9, 9];
  List validmove4 = [9, 9];
  List showMove = [];
  late List map;
  String winner = "";
  String reason = "";
  int whiteRemain = 12;
  int blackRemain = 12;
  late Map turn;
  bool loading = false;

  findmove(i, j, rl, ud) {
    int tempi = i + (1 * ud);
    int tempj = j + (1 * rl);
    if (inBoard(tempi, tempj)) {
      if (getPiece(tempi, tempj) == empty) {
        setmove(rl, ud, tempi, tempj);
      } else if (getPiece(tempi, tempj)["player"] == getPiece(i, j)["player"]) {
        setState(() {
          setmove(rl, ud, 9, 9);
        });
      } else {
        tempi = i + (2 * ud);
        tempj = j + (2 * rl);
        if (inBoard(tempi, tempj)) {
          if (getPiece(tempi, tempj) == empty) {
            setState(() {
              setmove(rl, ud, tempi, tempj);
            });
            tempi = i + (3 * ud);
            tempj = j + (3 * rl);
            if (inBoard(tempi, tempj)) {
              if (getPiece(tempi, tempj)["player"] == white["player"]) {
                tempi = i + (4 * ud);
                tempj = j + (4 * rl);
                if (inBoard(tempi, tempj)) {
                  if (getPiece(tempi, tempj) == empty) {
                    setState(() {
                      setmove(rl, ud, tempi, tempj);
                    });
                  }
                }
              }
            }
          } else {
            setState(() {
              setmove(rl, ud, 9, 9);
            });
          }
        } else {
          setState(() {
            setmove(rl, ud, 9, 9);
          });
        }
      }
    } else {
      setState(() {
        setmove(rl, ud, 9, 9);
      });
    }
  }

  setmove(rl, ud, i, j) {
    if (rl == 1 && ud == 1) {
      validmove4 = [i, j];
    } else if (rl == -1 && ud == 1) {
      validmove3 = [i, j];
    } else if (rl == 1 && ud == -1) {
      validmove1 = [i, j];
    } else if (rl == -1 && ud == -1) {
      validmove2 = [i, j];
    }
  }

  validMove(int i, int j) {
    findmove(i, j, 1, -1);
    findmove(i, j, -1, -1);
    if (getPiece(i, j) == blackKing) {
      findmove(i, j, 1, 1);
      findmove(i, j, -1, 1);
    }
  }

  movePiece(i, j) {
    int tempi = showMove[0];
    int tempj = showMove[1];
    if (tempi - i == 2 || tempi - i == -2) {
      int deli = ((i + tempi) / 2).truncate();
      int delj = ((j + tempj) / 2).truncate();
      removePiece(deli, delj);
      whiteRemain--;
    } else if (tempi - i == 4 || tempi - i == -4) {
      int tempdeli = ((i + tempi) / 2).truncate();
      int tempdelj = ((j + tempj) / 2).truncate();
      int deli1 = ((tempdeli + tempi) / 2).truncate();
      int delj1 = ((tempdelj + tempj) / 2).truncate();
      int deli2 = ((tempdeli + i) / 2).truncate();
      int delj2 = ((tempdelj + j) / 2).truncate();
      removePiece(deli1, delj1);
      removePiece(deli2, delj2);
      whiteRemain--;
      whiteRemain--;
    }
    setState(() {
      if (i == 0 && getPiece(tempi, tempj) == black) {
        currentState[i][j] = blackKing;
      } else {
        currentState[i][j] = getPiece(tempi, tempj);
      }
      removePiece(tempi, tempj);
      switchturn();
      showMove = [];
    });
    if (whiteRemain > 0) {
      updateboard();
    } else {
      setState(() {
        winner = "Black";
        reason = "No white piece remaining";
      });
    }
  }

  removePiece(i, j) {
    setState(() {
      currentState[i][j] = empty;
    });
  }

  switchturn() {
    setState(() {
      turn == white ? turn = black : turn = white;
    });
  }

  inBoard(i, j) {
    if ((i >= 0 && i < 8) && (j >= 0 && j < 8)) {
      return true;
    } else
      return false;
  }

  getPiece(i, j) {
    return currentState[i][j];
  }

  Future getmove() async {
    List board = [
      [for (int i = 0; i < 8; i++) map.indexOf(currentState[0][i])],
      [for (int i = 0; i < 8; i++) map.indexOf(currentState[1][i])],
      [for (int i = 0; i < 8; i++) map.indexOf(currentState[2][i])],
      [for (int i = 0; i < 8; i++) map.indexOf(currentState[3][i])],
      [for (int i = 0; i < 8; i++) map.indexOf(currentState[4][i])],
      [for (int i = 0; i < 8; i++) map.indexOf(currentState[5][i])],
      [for (int i = 0; i < 8; i++) map.indexOf(currentState[6][i])],
      [for (int i = 0; i < 8; i++) map.indexOf(currentState[7][i])]
    ];
    final response = await http.post(
      Uri.parse('https://checkers-ai.herokuapp.com/${widget.ai}'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"depth": widget.difficulty, "turn": 1, "board": board}),
    );
    if (response.statusCode == 200) {
      var serverResponse = response.body;
      final data = json.decode(serverResponse);
      return data['board'];
    } else {
      print(response.reasonPhrase);
    }
  }

  updateboard() async {
    List pieces = [];
    bool moveAvailable = false;
    setState(() {
      loading = true;
    });
    List responseBoard = await getmove();
    List currentBoard = [
      for (int i = 0; i < 8; i++)
        for (int j = 0; j < 8; j++) map.indexOf(currentState[i][j])
    ];
    List tempBoard = [
      for (int i = 0; i < 8; i++)
        for (int j = 0; j < 8; j++) responseBoard[i][j]
    ];
    List newBoard = [
      [for (int i = 0; i < 8; i++) map[responseBoard[0][i]]],
      [for (int i = 0; i < 8; i++) map[responseBoard[1][i]]],
      [for (int i = 0; i < 8; i++) map[responseBoard[2][i]]],
      [for (int i = 0; i < 8; i++) map[responseBoard[3][i]]],
      [for (int i = 0; i < 8; i++) map[responseBoard[4][i]]],
      [for (int i = 0; i < 8; i++) map[responseBoard[5][i]]],
      [for (int i = 0; i < 8; i++) map[responseBoard[6][i]]],
      [for (int i = 0; i < 8; i++) map[responseBoard[7][i]]]
    ];
    print("current board state: " + currentBoard.toString());
    print("Updated board state:" + tempBoard.toString());
    whiteRemain = 0;
    blackRemain = 0;
    if (IterableEquality().equals(currentBoard, tempBoard)) {
      setState(() {
        loading = false;
      });
      setState(() {
        winner = "Black";
        reason = "No moves left for White";
      });
    } else {
      currentState = newBoard;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (currentState[i][j]["player"] == 1) {
            whiteRemain++;
          } else if (currentState[i][j]["player"] == 2) {
            blackRemain++;
          }
        }
      }
      if (whiteRemain == 0) {
        winner = "Black";
        reason = "No white piece remaining";
      } else if (blackRemain == 0) {
        winner = "White";
        reason = "No Black piece remaining";
      }
      setState(() {
        loading = false;
      });
      switchturn();
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (getPiece(i, j)['player'] == 2) {
            pieces.add([i, j]);
          }
        }
      }
      for (int i = 0; i < pieces.length; i++) {
        validMove(pieces[i][0], pieces[i][1]);
        if (validmove1 != [9, 9] ||
            validmove2 != [9, 9] ||
            validmove3 != [9, 9] ||
            validmove4 != [9, 9]) {
          moveAvailable = true;
          break;
        }
      }
      if (moveAvailable == false) {
        setState(() {
          winner = "White";
          reason = "No moves left for black";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentState = [
      [empty, white, empty, white, empty, white, empty, white],
      [white, empty, white, empty, white, empty, white, empty],
      [empty, white, empty, white, empty, white, empty, white],
      [empty, empty, empty, empty, empty, empty, empty, empty],
      [empty, empty, empty, empty, empty, empty, empty, empty],
      [black, empty, black, empty, black, empty, black, empty],
      [empty, black, empty, black, empty, black, empty, black],
      [black, empty, black, empty, black, empty, black, empty],
    ];
    initialState = [
      [empty, white, empty, white, empty, white, empty, white],
      [white, empty, white, empty, white, empty, white, empty],
      [empty, white, empty, white, empty, white, empty, white],
      [empty, empty, empty, empty, empty, empty, empty, empty],
      [empty, empty, empty, empty, empty, empty, empty, empty],
      [black, empty, black, empty, black, empty, black, empty],
      [empty, black, empty, black, empty, black, empty, black],
      [black, empty, black, empty, black, empty, black, empty],
    ];
    turn = black;
    map = [empty, white, black, whiteKing, blackKing];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          color: Colors.blue,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (int i = 0; i < 8; i++)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int j = 0; j < 8; j++)
                  Container(
                    height: 40,
                    width: 40,
                    color: (i + j).isEven ? Colors.white : Colors.black,
                    child: currentState[i][j] == white ||
                            currentState[i][j] == black ||
                            currentState[i][j] == whiteKing ||
                            currentState[i][j] == blackKing
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                if (turn == black) {
                                  validmove1 = [9, 9];
                                  validmove2 = [9, 9];
                                  validmove3 = [9, 9];
                                  validmove4 = [9, 9];
                                  if (showMove.length == 0)
                                    showMove = [i, j];
                                  else if (showMove[0] == i && showMove[1] == j)
                                    showMove = [];
                                  else
                                    showMove = [i, j];
                                }
                              });
                              if (showMove.length != 0) {
                                turn == black &&
                                        getPiece(showMove[0], showMove[1])[
                                                "player"] ==
                                            2
                                    ? validMove(i, j)
                                    : {};
                              }
                            },
                            child: Piece(
                              player: currentState[i][j]["player"],
                              king: currentState[i][j]["king"],
                            ))
                        : showMove.length != 0 &&
                                ((validmove1[0] == i && validmove1[1] == j) ||
                                    (validmove2[0] == i &&
                                        validmove2[1] == j) ||
                                    (validmove3[0] == i &&
                                        validmove3[1] == j) ||
                                    (validmove4[0] == i && validmove4[1] == j))
                            ? Opacity(
                                opacity: 0.3,
                                child: GestureDetector(
                                  onTap: () {
                                    movePiece(i, j);
                                    setState(() {
                                      validmove1 = [9, 9];
                                      validmove2 = [9, 9];
                                    });
                                  },
                                  child: Piece(
                                    player: turn["player"],
                                    king: (i == 0 && turn == black) ||
                                            (i == 7 && turn == white)
                                        ? true
                                        : false,
                                  ),
                                ))
                            : Container(),
                  )
              ]),
          ])),
      Positioned(
          top: 60,
          left: 16,
          child: Text(
            "White Remaining: " + whiteRemain.toString(),
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                color: Colors.white),
          )),
      Positioned(
          bottom: 60,
          right: 16,
          child: Text(
            "Black Remaining: " + blackRemain.toString(),
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                color: Colors.white),
          )),
      loading
          ? Positioned(
              top: 130,
              left: (MediaQuery.of(context).size.width * 0.5) - 75,
              child: Container(
                  width: 150,
                  height: 40,
                  child: Row(children: [
                    Material(child: Text("AI is Thinking ")),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white))
                  ])))
          : Container(),
      winner == ""
          ? Container()
          : Stack(children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    winner = "";
                    reason = "";
                    blackRemain = 12;
                    whiteRemain = 12;
                    currentState = initialState;
                    turn = black;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black,
                  child: Image.asset("assets/gameover.gif"),
                ),
              ),
              Positioned(
                bottom: 100,
                left: MediaQuery.of(context).size.width * 0.5 - 110,
                child: Container(
                  alignment: Alignment.center,
                  width: 220,
                  child: Text("WINNER is " + winner,
                      style: TextStyle(
                          letterSpacing: 1.75,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontSize: 14)),
                ),
              ),
              Positioned(
                bottom: 70,
                left: MediaQuery.of(context).size.width * 0.5 - 140,
                child: Container(
                  alignment: Alignment.center,
                  width: 280,
                  child: Text(reason,
                      style: TextStyle(
                          letterSpacing: 1.75,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontSize: 14)),
                ),
              ),
            ]),
      Positioned(
        bottom: 20,
        left: 20,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Pause()));
            },
            child: Icon(Icons.pause, color: Colors.white)),
      )
    ]);
  }
}
