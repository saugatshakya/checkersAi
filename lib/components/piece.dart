import 'package:flutter/material.dart';

class Piece extends StatelessWidget {
  final int player;
  final bool king;
  Piece({required this.player, required this.king});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
              color: player == 1 ? Colors.black : Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(25),
          color: player == 1 ? Colors.grey[200] : Colors.black),
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color: player == 1 ? Colors.black : Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(25),
            color: player == 1 ? Colors.grey[100] : Colors.black),
        child: king
            ? Center(
                child: Text(
                  "K",
                  style:
                      TextStyle(fontSize: 14, decoration: TextDecoration.none),
                ),
              )
            : Container(),
      ),
    );
  }
}
