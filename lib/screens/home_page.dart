import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import '../constants.dart';

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
      body: SingleChildScrollView(
        child: Column(
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

class _GameBoardState extends State<GameBoard> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

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
      constraints: const BoxConstraints(minHeight: 400, minWidth: 400),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0.0) {
            _moveRight();
          } else if (details.primaryVelocity != null &&
              details.primaryVelocity! < 0.0) {
            _moveLeft();
          }
        },
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Stack(
            children: List.generate(
              16,
              (index) => Tile(
                  boardData: _boardData,
                  crossAxisCount: _crossAxisCount,
                  tileIndex: index),
            ),
          ),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required List<List<int>> boardData,
    required int crossAxisCount,
    required int tileIndex,
  })  : _boardData = boardData,
        _crossAxisCount = crossAxisCount,
        _tileIndex = tileIndex,
        super(key: key);

  final List<List<int>> _boardData;
  final int _crossAxisCount;
  final int _tileIndex;

  @override
  Widget build(BuildContext context) {
    final gridSize = 400.0;
    final boxSize = (gridSize / 4) - (2 * 8.0);
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        height: gridSize,
        width: gridSize,
        child: AnimatedAlign(
          alignment: FractionalOffset((_tileIndex ~/ _crossAxisCount) / 3,
              (_tileIndex % _crossAxisCount) / 3),
          duration: const Duration(seconds: 1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              color: _boardData[_tileIndex ~/ _crossAxisCount]
                          [_tileIndex % _crossAxisCount] !=
                      -1
                  ? const Color(0xffefe5da)
                  : const Color(0xffd6cdc4),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(
                  minHeight: 80,
                  minWidth: 80,
                ),
                child: Text(
                  _boardData[_tileIndex ~/ _crossAxisCount]
                              [_tileIndex % _crossAxisCount] !=
                          -1
                      ? "${pow(2, Random().nextInt(11))}"
                      : "",
                  style: kTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
