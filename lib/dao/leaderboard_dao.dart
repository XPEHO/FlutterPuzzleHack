import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardDao {
  Future<DocumentSnapshot> fetchUserScore(String pseudo) =>
      FirebaseFirestore.instance.collection("scores").doc(pseudo).get();

  Future<QuerySnapshot<Map<String, dynamic>>> fetchScores() =>
      FirebaseFirestore.instance.collection("scores").get();

  updateUserScore(String pseudo, int score) async {
    await FirebaseFirestore.instance.collection("scores").doc(pseudo).set(
      {
        "value": score,
      },
      SetOptions(merge: true),
    );
  }
}
