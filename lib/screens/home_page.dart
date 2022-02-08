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

class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kGameBoardColor,
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          shrinkWrap: true,
          children: List.generate(
            16,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffefe5da),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${pow(2, index)}",
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
  }
}
