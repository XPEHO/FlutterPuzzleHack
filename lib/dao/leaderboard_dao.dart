import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardDao {
  Future<DocumentSnapshot> fetchUserScore(String nickname) =>
      FirebaseFirestore.instance.collection("scores").doc(nickname).get();

  Future<QuerySnapshot<Map<String, dynamic>>> fetchScores() =>
      FirebaseFirestore.instance.collection("scores").get();

  updateUserScore(String nickname, int score) async {
    DocumentSnapshot userDocument =
        await LeaderboardDao().fetchUserScore(nickname);

    if (userDocument.data() == null) {
      await FirebaseFirestore.instance.collection("scores").doc(nickname).set(
        {
          "value": score,
        },
        SetOptions(merge: true),
      );
    } else {
      Map<String, dynamic> storedScore =
          userDocument.data() as Map<String, dynamic>;
      if (score < storedScore["value"]) {
        await FirebaseFirestore.instance.collection("scores").doc(nickname).set(
          {
            "value": score,
          },
          SetOptions(merge: true),
        );
      }
    }
  }
}
