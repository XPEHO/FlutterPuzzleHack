import 'package:get_it/get_it.dart';
import 'package:puzzle/services/leaderboard_service.dart';

class LeaderboardProvider {
  final leaderboardService = GetIt.I.get<LeaderboardService>();

  Future<int> fetchUserScore(String pseudo) async {
    return await leaderboardService.fetchUserScore(pseudo);
  }

  Future<Map<String, dynamic>> fetchScores() async {
    return await leaderboardService.fetchScores();
  }

  void updateUserScore(int score) {
    leaderboardService.updateUserScore(score);
  }

  void updateUserPseudo(String pseudo) {
    leaderboardService.pseudo = pseudo;
  }

  String getUserPseudo() {
    return leaderboardService.pseudo;
  }
}
