import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/constants.dart';
import '../providers/user_data_provider.dart';
import 'widgets/game_board_widget.dart';
import '../models/user_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kModifiedScaffoldColor,
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
            const UserScoreWidget(),
            const GameBoard(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Undo',
                        style: kTextStyle.copyWith(fontSize: 40),
                      ),
                    ),
                    style: kButtonStyle.copyWith(
                      backgroundColor:
                          MaterialStateProperty.all(kButtonBgColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'New Game',
                        style: kTextStyle.copyWith(fontSize: 40),
                      ),
                    ),
                    style: kButtonStyle.copyWith(
                      backgroundColor:
                          MaterialStateProperty.all(kButtonBgColor),
                    ),
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

class UserScoreWidget extends StatelessWidget {
  const UserScoreWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          const Text(
            'Score',
            style: kTextStyle,
          ),
          Consumer(
            builder: ((context, ref, child) {
              final userScore = ref.watch<UserData>(userScoreProvider).score;
              return Text(
                userScore.toString(),
                style: kBoardStyle.copyWith(fontSize: 70),
              );
            }),
          ),
        ],
      ),
    );
  }
}
