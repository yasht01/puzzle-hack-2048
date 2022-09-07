import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_2048/providers/user_data_provider.dart';

import '../../../utils/constants.dart';
import '../../components/tile.dart';

class GameBoard extends ConsumerStatefulWidget {
  const GameBoard({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends ConsumerState<GameBoard> with TickerProviderStateMixin {
  late AnimationController _controller;

  List<List<Tile>> grid = List.generate(
      4, (y) => List.generate(4, (x) => Tile(x: x, y: y, value: 0)));
  List<Tile> toAdd = [];
  Iterable<Tile> get flattenedGrid => grid.expand((element) => element);
  Iterable<List<Tile>> get cols =>
      List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        for (var element in toAdd) {
          grid[element.x][element.y].value = element.value;
        }
        for (var element in flattenedGrid) {
          element.resetAnimations();
        }
        toAdd.clear();
      }
    });

    grid[1][1].value = 2;
    // grid[1][2].value = 8;
    grid[0][2].value = 2;
    // grid[0][0].value = 16;
    // grid[0][1].value = 16;
    // grid[1][0].value = 32;

    for (var tile in flattenedGrid) {
      tile.resetAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = MediaQuery.of(context).size.width * 0.9;
    final tileSize = gridSize / 4 - 2 * 4.0;
    List<Widget> stackItems = [];
    stackItems.addAll(
      flattenedGrid.map(
        (e) => Positioned(
          left: e.x * tileSize,
          top: e.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
            child: Container(
              width: tileSize - 2 * 4.0,
              height: tileSize - 2 * 4.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kTileBorderRadius),
                color: const Color(0xffefe5d9),
              ),
            ),
          ),
        ),
      ),
    );
    stackItems.addAll(
      [flattenedGrid, toAdd].expand((element) => element).map(
            (e) => AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => e.animatedValue.value == 0
                  ? const SizedBox()
                  : Positioned(
                      left: e.animatedX.value * tileSize,
                      top: e.animatedY.value * tileSize,
                      width: tileSize,
                      height: tileSize,
                      child: Center(
                        child: Material(
                          elevation: 2,
                          borderRadius:
                              BorderRadius.circular(kTileBorderRadius),
                          color: const Color(0xffefe5d9),
                          child: Container(
                            width: (tileSize - 2 * 4.0) * e.scale.value,
                            height: (tileSize - 2 * 4.0) * e.scale.value,
                            padding: const EdgeInsets.all(8.0),
                            constraints: BoxConstraints.tight(
                                Size.square(tileSize - 2 * 4.0)),
                            child: FittedBox(
                              child: Text(
                                e.value.toString(),
                                style: kBoardStyle,
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
        onHorizontalDragEnd: onHorizontalDragEnd,
        onVerticalDragEnd: onVerticalDragEnd,
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

  void onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < 0 && canSwipeLeft()) {
      swipe(swipeLeft);
    } else if (details.primaryVelocity! > 0 && canSwipeRight()) {
      swipe(swipeRight);
    }
  }

  void onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0 && canSwipeDown()) {
      swipe(swipeDown);
    } else if (details.primaryVelocity! < 0 && canSwipeUp()) {
      swipe(swipeUp);
    }
  }

  //TODO: Add web support

  // void _handleKeyEvent(RawKeyEvent event) {
  //   if (event.logicalKey == LogicalKeyboardKey.arrowUp && canSwipeUp()) {
  //     swipe(swipeUp);
  //   } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
  //       canSwipeDown()) {
  //     swipe(swipeDown);
  //   } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
  //       canSwipeLeft()) {
  //     swipe(swipeLeft);
  //   } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
  //       canSwipeRight()) {
  //     swipe(swipeRight);
  //   }
  // }

  void swipe(void Function() swipeFn) {
    setState(() {
      swipeFn();
      addRandomTile();
      _controller.forward(from: 0);
    });
  }

  void addRandomTile() {
    List<Tile> emptyTiles =
        flattenedGrid.where((element) => element.value == 0).toList();
    emptyTiles.shuffle();

    toAdd.add(Tile(x: emptyTiles.first.x, y: emptyTiles.first.y, value: 2)
      ..appear(_controller));
  }

  bool canSwipeLeft() => grid.any(canSwipe);
  bool canSwipeRight() => grid.map((e) => e.reversed.toList()).any(canSwipe);
  bool canSwipeUp() => cols.any(canSwipe);
  bool canSwipeDown() => cols.map((e) => e.reversed.toList()).any(canSwipe);

  void swipeLeft() => grid.forEach(mergeTiles);
  void swipeRight() => grid.map((e) => e.reversed.toList()).forEach(mergeTiles);
  void swipeUp() => cols.forEach(mergeTiles);
  void swipeDown() => cols.map((e) => e.reversed.toList()).forEach(mergeTiles);

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
          firstNonZeroTile.moveTo(_controller, tiles[i].x, tiles[i].y);
          if (secondNonZeroTile.value != -1) {
            newValue += secondNonZeroTile.value;
            ref.read(userScoreProvider).score += newValue;
            print(ref.read(userScoreProvider).score);
            ref.refresh(userScoreProvider);
            secondNonZeroTile.moveTo(_controller, tiles[i].x, tiles[i].y);
            secondNonZeroTile.bounce(_controller);
            secondNonZeroTile.changeNumber(_controller, newValue);
            secondNonZeroTile.value = 0;
            secondNonZeroTile.changeNumber(_controller, 0);
          }
          firstNonZeroTile.value = 0;
          tiles[i].value = newValue;
        }
      }
    }
  }
}
