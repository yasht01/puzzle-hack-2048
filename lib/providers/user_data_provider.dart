import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_data.dart';

final userScoreProvider =
    StateNotifierProvider<UserDataNotifier, int>((ref) => UserDataNotifier());
