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
  late AnimationController _controller;

  List<List<Tile>> grid = List.generate(
      4, (y) => List.generate(4, (x) => Tile(x: x, y: y, value: 0)));
  Iterable<Tile> get flattenedGrid => grid.expand((element) => element);
  Iterable<List<Tile>> get cols =>
      List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        for (var element in flattenedGrid) {
          element.resetAnimations();
        }
      }
    });

    grid[1][1].value = 4;
    grid[1][2].value = 8;
    grid[0][0].value = 16;
    grid[0][1].value = 16;
    grid[1][0].value = 32;

    for (var tile in flattenedGrid) {
      tile.resetAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = MediaQuery.of(context).size.height * 0.6 - 2 * 16.0;
    final tileSize = gridSize / 4 - 2 * 4.0;
    List<Widget> stackItems = [];
    stackItems.addAll(
      flattenedGrid.map(
        (e) => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => e.animatedValue.value == 0
              ? const SizedBox()
              : Positioned(
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
                        constraints: BoxConstraints.tight(
                            Size.square(tileSize - 2 * 4.0)),
                        child: FittedBox(
                          child: Text(
                            e.value.toString(),
                            style: kTextStyle,
                          ),
                        ),
                      ),
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
          if (details.velocity.pixelsPerSecond.dx > 250 && canSwipeRight()) {
            // Swipe Right
            swipe(swipeRight);
          } else if (details.velocity.pixelsPerSecond.dx < -250 &&
              canSwipeLeft()) {
            // Swipe Left
            swipe(swipeLeft);
          }
        },
        onVerticalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dy > 250 && canSwipeDown()) {
            // Swipe Down
            swipe(swipeDown);
          } else if (details.velocity.pixelsPerSecond.dy < -250 &&
              canSwipeUp()) {
            // Swipe Up
            swipe(swipeUp);
          }
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

  void swipe(void Function() swipeFn) {
    setState(() {
      swipeFn();
      // add new tile
      _controller.forward(from: 0);
    });
  }

  bool canSwipeLeft() => grid.any(canSwipe);
  bool canSwipeRight() => grid.map((e) => e.reversed.toList()).any(canSwipe);
  bool canSwipeUp() => cols.any(canSwipe);
  bool canSwipeDown() => cols.map((e) => e.reversed.toList()).any(canSwipe);

  bool canSwipe(List<Tile> row) {
    for (int i = 0; i < row.length; i++) {
      if (row[i].value == 0) {
        if (row.skip(i + 1).any((e) => e.value != 0)) {
          return true;
        }
      } else {
        Tile hasNonZeroVal = row.skip(i + 1).firstWhere((e) => e.value != 0,
            orElse: () => Tile(x: 0, y: 0, value: -1));
        if (hasNonZeroVal.value != -1 && hasNonZeroVal.value == row[i].value) {
          return true;
        }
      }
    }
    return false;
  }

  void swipeLeft() => grid.forEach(mergeTiles);
  void swipeRight() => grid.map((e) => e.reversed.toList()).forEach(mergeTiles);
  void swipeUp() => cols.forEach(mergeTiles);
  void swipeDown() => cols.map((e) => e.reversed.toList()).forEach(mergeTiles);

  void mergeTiles(List<Tile> tiles) {
    // Find the first non-zero tile
    // Find the second non-zero tile
    // merge tiles *if possible*
    // Repeat from step 1 until the end of the Iterable<Tile>

    for (int i = 0; i < tiles.length; i++) {
      List<Tile> toCheck =
          tiles.skip(i).skipWhile((tile) => tile.value == 0).toList();
      if (toCheck.isNotEmpty) {
        Tile firstNonZeroTile = toCheck.first;
        Tile secondNonZeroTile = toCheck.skip(i + 1).firstWhere(
            (tile) => tile.value != 0,
            orElse: () => Tile(x: 0, y: 0, value: -1));

        if (secondNonZeroTile.value != -1 &&
            secondNonZeroTile.value != firstNonZeroTile.value) {
          secondNonZeroTile = Tile(x: 0, y: 0, value: -1);
        }

        if (tiles[i] != firstNonZeroTile || secondNonZeroTile.value != -1) {
          int newValue = firstNonZeroTile.value;
          if (secondNonZeroTile.value != -1) {
            newValue += secondNonZeroTile.value;
            secondNonZeroTile.value = 0;
          }
          firstNonZeroTile.value = 0;
          tiles[i].value = newValue;
        }
      }
    }
  }
}
