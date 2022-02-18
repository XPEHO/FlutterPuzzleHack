import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:puzzle/providers/leaderboard_provider.dart';
import 'package:puzzle/view/leaderboard_page/widgets/scores_list.dart';
import 'package:puzzle/view/leaderboard_page/widgets/user_score.dart';

class LeaderboardPage extends StatefulWidget {
  static const String route = "/leaderboardPage";
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Map<String, dynamic> scores = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder(
        future: LeaderboardProvider().fetchScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          scores = snapshot.data as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: UserScore(),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ScoresList(scores),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
