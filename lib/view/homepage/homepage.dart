import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle/providers/leaderboard_provider.dart';
import 'package:puzzle/services/shared.dart';
import 'package:puzzle/view/homepage/widgets/menu_button.dart';
import 'package:puzzle/view/view.dart';

class HomePage extends StatefulWidget {
  static const String route = "/homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  String nickname = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.team_name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 48,
                    fontFamily: "QueenOfTheModernAge",
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    if (isFirebaseUsable())
                      TextFormField(
                        cursorWidth: 1,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.nickname_hint,
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
                        onChanged: (term) {
                          setState(() {
                            nickname = term;
                          });
                        },
                      ),
                    const SizedBox(height: 16),
                    MenuButton(
                      redirection: () {
                        LeaderboardProvider().updateUserNickname(nickname);
                        GoRouter.of(context).go(
                          PuzzlePage.route,
                        );
                      },
                      text: AppLocalizations.of(context)!.play,
                      isClickable: nickname.isNotEmpty,
                    ),
                  ],
                ),
              ),
            ),
            if (isFirebaseUsable())
              Expanded(
                child: Center(
                  child: MenuButton(
                    redirection: () => GoRouter.of(context).go(
                      LeaderboardPage.route,
                    ),
                    text: AppLocalizations.of(context)!.leaderboard_btn,
                    isClickable: true,
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: MenuButton(
                  redirection: () => GoRouter.of(context).go(
                    LeaderboardPage.route,
                  ),
                  text: AppLocalizations.of(context)!.leaderboard_btn,
                  isClickable: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
