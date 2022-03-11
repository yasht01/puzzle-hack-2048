import 'package:flutter/material.dart';
import '../constants.dart';
import '../game_board.dart';

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
