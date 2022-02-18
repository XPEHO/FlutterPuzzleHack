import 'package:puzzle/services/leaderboard_service.dart';

class LeaderboardProvider {
  Future<int> fetchUserScore(String pseudo) async {
    return await LeaderboardService().fetchUserScore(pseudo);
  }

  Future<Map<String, dynamic>> fetchScores() async {
    return await LeaderboardService().fetchScores();
  }
}
