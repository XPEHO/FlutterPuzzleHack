import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puzzle/dao/leaderboard_dao.dart';

class LeaderboardService {
  Future<int> fetchUserScore(String pseudo) async {
    DocumentSnapshot userDocument =
        await LeaderboardDao().fetchUserScore(pseudo);
    if (userDocument.data() == null) {
      return 0;
    } else {
      Map<String, dynamic> score = userDocument.data() as Map<String, dynamic>;
      return score["value"];
    }
  }

  Future<Map<String, dynamic>> fetchScores() async {
    QuerySnapshot<Map<String, dynamic>> scoresSnapshot =
        await LeaderboardDao().fetchScores();
    Map<String, dynamic> scores = {};

    if (scoresSnapshot.docs.isEmpty) {
      return scores;
    } else {
      for (var document in scoresSnapshot.docs) {
        scores.putIfAbsent(document.id, () => document.data().values.first);
      }
      return scores;
    }
  }
}
