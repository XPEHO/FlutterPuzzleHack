import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puzzle/dao/leaderboard_dao.dart';

class LeaderboardService {
  String nickname = "";

  Future<int> fetchUserScore(String nickname) async {
    DocumentSnapshot userDocument =
        await LeaderboardDao().fetchUserScore(nickname);
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

    if (scoresSnapshot.docs.isEmpty) {
      return {};
    } else {
      return getTenFirstUsers(scoresSnapshot);
    }
  }

  Map<String, dynamic> getTenFirstUsers(
      QuerySnapshot<Map<String, dynamic>> scoresSnapshot) {
    Map<String, dynamic> scores = {};
    Map<String, dynamic> tenFirst = {};

    for (var document in scoresSnapshot.docs) {
      scores.putIfAbsent(document.id, () => document.data().values.first);
    }

    var sortedUsers = scores.keys.toList(growable: false)
      ..sort((user1, user2) => scores[user1].compareTo(scores[user2]));
    Map<String, dynamic> sortedScores = {
      for (var user in sortedUsers) user: scores[user]
    };

    for (var index = 0; index < 10; index++) {
      tenFirst.putIfAbsent(sortedScores.keys.elementAt(index),
          () => sortedScores.values.elementAt(index));
    }

    return tenFirst;
  }

  void updateUserScore(int score) {
    LeaderboardDao().updateUserScore(nickname, score);
  }
}
