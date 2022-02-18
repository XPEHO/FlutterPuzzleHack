import 'package:flutter/material.dart';
import 'package:puzzle/providers/leaderboard_provider.dart';

class UserScore extends StatefulWidget {
  const UserScore({Key? key}) : super(key: key);

  @override
  State<UserScore> createState() => _UserScoreState();
}

class _UserScoreState extends State<UserScore> {
  final formKey = GlobalKey<FormState>();
  Future? _futureFetchUserScore;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureFetchUserScore,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Form(
              key: formKey,
              child: TextFormField(
                cursorWidth: 1,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Pseudo...",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.search),
                  ),
                  contentPadding: const EdgeInsets.all(12.0),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600]!,
                ),
                onFieldSubmitted: (pseudo) async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      _futureFetchUserScore =
                          LeaderboardProvider().fetchUserScore(pseudo);
                    });
                  }
                },
                validator: (pseudo) => _validateValue(pseudo!),
              ),
            );
          } else {
            return Text("Your score: ${snapshot.data}");
          }
        });
  }

  String? _validateValue(String pseudo) {
    if (pseudo.isEmpty) {
      return "Pseudo can't be null";
    }
    return null;
  }
}
