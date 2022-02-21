import 'package:get_it/get_it.dart';
import 'package:puzzle/services/leaderboard_service.dart';

class LeaderboardProvider {
  final leaderboardService = GetIt.I.get<LeaderboardService>();

  Future<int> fetchUserScore(String nickname) async {
    return await leaderboardService.fetchUserScore(nickname);
  }

  Future<Map<String, dynamic>> fetchScores() async {
    return await leaderboardService.fetchScores();
  }

  void updateUserScore(int score) {
    leaderboardService.updateUserScore(score);
  }

  void updateUserNickname(String nickname) {
    leaderboardService.nickname = nickname;
  }

  String getUserNickname() {
    return leaderboardService.nickname;
  }
}
