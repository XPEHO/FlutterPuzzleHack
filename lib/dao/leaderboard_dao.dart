import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardDao {
  Future<DocumentSnapshot> fetchUserScore(String nickname) =>
      FirebaseFirestore.instance.collection("scores").doc(nickname).get();

  Future<QuerySnapshot<Map<String, dynamic>>> fetchScores() =>
      FirebaseFirestore.instance.collection("scores").get();

  updateUserScore(String nickname, int score) async {
    await FirebaseFirestore.instance.collection("scores").doc(nickname).set(
      {
        "value": score,
      },
      SetOptions(merge: true),
    );
  }
}
