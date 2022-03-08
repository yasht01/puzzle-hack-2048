import 'package:flutter/material.dart';

const Color kScaffoldBackgroudColor = Color(0xfffaf8ef);
const Color kModifiedScaffoldColor = Color(0xffce4257);
const Color kGameBoardColor = Color.fromARGB(255, 70, 63, 57);
const Color kButtonTextColor = Color.fromARGB(255, 0, 0, 0);
const Color kButtonBgColor = Color(0xffefe5d9);

var kButtonStyle = TextButton.styleFrom(
  backgroundColor: const Color(0xff907a65),
  elevation: 4,
  splashFactory: InkRipple.splashFactory,
  primary: const Color(0xffd6cdc4),
);

const TextStyle kTextStyle = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.w500,
    fontFamily: 'Deftone Stylus',
    color: kButtonTextColor);

const TextStyle kBoardStyle = TextStyle(
  fontSize: 40,
  fontFamily: 'Franchise',
);
