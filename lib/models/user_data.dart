import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDataNotifier extends StateNotifier<int> {
  UserDataNotifier() : super(0);

  void add(int score) {
    state += score;
  }
}