import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle_2048/components/tile.dart';
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
  // late final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 2),
  //   vsync: this,
  // );

  List<List<Tile>> grid =
      List.generate(4, (x) => List.generate(4, (y) => Tile(x: x, y: y)));
  Iterable<Tile> get flattenedGrid => grid.expand((element) => element);

  // void _moveRight() {
  //   setState(() {
  //     _boardData[0][1] = -1;
  //     _boardData[0][3] = 1;
  //     _tileData[1][0] = const FractionalOffset(3 / 3, 0 / 3);
  //     _tileData[3][0] = const FractionalOffset(1 / 3, 0 / 3);
  //   });
  // }

  // void _moveLeft() {
  //   setState(() {
  //     _boardData[0][3] = -1;
  //     _boardData[0][1] = 1;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final gridSize = MediaQuery.of(context).size.height * 0.6;
    final tileSize = gridSize / 4 - 2 * 4.0;
    List<Positioned> stackItems = [];
    stackItems.addAll(
      flattenedGrid.map(
        (e) => Positioned(
          left: e.x * tileSize,
          top: e.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffefe5d9),
              child: Container(
                width: tileSize - 2 * 4.0,
                height: tileSize - 2 * 4.0,
                padding: const EdgeInsets.all(8.0),
                constraints:
                    BoxConstraints.tight(Size.square(tileSize - 2 * 4.0)),
                child: e.value != null 
                    ? FittedBox(
                        child: Text(
                          e.value.toString(),
                          style: kTextStyle,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kGameBoardColor,
      ),
      constraints: BoxConstraints.tight(Size.square(gridSize)),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          // if (details.primaryVelocity != null &&
          //     details.primaryVelocity! > 0.0) {
          //   _moveRight();
          // } else if (details.primaryVelocity != null &&
          //     details.primaryVelocity! < 0.0) {
          //   _moveLeft();
          // }
        },
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Stack(
            children: stackItems,
          ),
        ),
      ),
    );
  }
}
