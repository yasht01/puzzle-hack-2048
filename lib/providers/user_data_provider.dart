import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_data.dart';

final userScoreProvider = StateProvider<UserData>((ref) => UserData(score: 0));
