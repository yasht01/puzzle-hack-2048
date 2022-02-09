import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle_2048/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroudColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xff907a65),
          child: const Icon(Icons.settings),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: const [
                Text(
                  'Score',
                  style: kTextStyle,
                ),
                Text(
                  '0',
                  style: kTextStyle,
                ),
              ],
            ),
          ),
          const GameBoard(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Undo',
                    style: kTextStyle.copyWith(color: Colors.white),
                  ),
                  style: kButtonStyle,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'New Game',
                    style: kTextStyle.copyWith(color: Colors.white),
                  ),
                  style: kButtonStyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<int>> _boardData = [
    [0, 1, -1, -1],
    [1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1]
  ];

  final _crossAxisCount = 4;

  void _moveRight() {
    setState(() {
      _boardData[0][1] = -1;
      _boardData[0][3] = 1;
    });
  }

  void _moveLeft() {
    setState(() {
      _boardData[0][3] = -1;
      _boardData[0][1] = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kGameBoardColor,
      ),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if(details.primaryVelocity != null && details.primaryVelocity! > 0.0) {
            _moveRight();
          } else if(details.primaryVelocity != null && details.primaryVelocity! < 0.0) {
            _moveLeft();
          }
          print(details.primaryVelocity);
        },
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: _crossAxisCount,
            shrinkWrap: true,
            children: List.generate(
              16,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(20),
                  color: _boardData[index ~/ _crossAxisCount][index % _crossAxisCount] != -1 ? const Color(0xffefe5da) : const Color(0xffd6cdc4),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _boardData[index ~/ _crossAxisCount][index % _crossAxisCount] != -1 ? "${pow(2, Random().nextInt(11))}" : "",
                        style: kTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
