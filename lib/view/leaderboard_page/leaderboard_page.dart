import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle/providers/leaderboard_provider.dart';
import 'package:puzzle/view/homepage/homepage.dart';
import 'package:puzzle/view/leaderboard_page/widgets/scores_list.dart';
import 'package:puzzle/view/leaderboard_page/widgets/user_score.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/shared.dart';

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
      appBar: AppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(
            left: 4.0,
            top: 8.0,
          ),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go(HomePage.route),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
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
            padding: const EdgeInsets.only(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  headerSuperman(),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8.0),
                    child: isMobile()
                        ? Text(
                            AppLocalizations.of(context)!.leader_board_subtitle,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.leader_board_subtitle,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: UserScore(),
                  ),
                  ScoresList(scores),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget headerSuperman() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 6.0,
        top: 16.0,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          Text(
            'Leader ',
            style: isMobile()
                ? TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                  )
                : TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 48,
                  ),
          ),
          Text(
            'Board',
            style: isMobile()
                ? TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)
                : TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
          ),
          isMobile()
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    width: 50.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/mascotte.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    width: 200.0,
                    height: 300.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/mascotte.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
