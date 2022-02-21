import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle/providers/leaderboard_provider.dart';
import 'package:puzzle/services/shared.dart';
import 'package:puzzle/view/homepage/widgets/menu_button.dart';
import 'package:puzzle/view/view.dart';

class HomePage extends StatefulWidget {
  static const String route = '/homePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  String nickname = '';
  bool darkmode = false;

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  darkModeButton(),
                  levelButton(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: headerHomePage(context),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 9.0,
                bottom: 9.0,
              ),
              child: MenuButton(
                redirection: () {
                  LeaderboardProvider().updateUserNickname(nickname);
                  GoRouter.of(context).go(
                    PuzzlePage.route,
                  );
                },
                text: AppLocalizations.of(context)!.play,
                isClickable: nickname.isNotEmpty,
              ),
            ),
          ),
          if (isFirebaseUsable())
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 9.0,
                  bottom: 9.0,
                ),
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
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: bottomBadges(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerHomePage(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.team_name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'QueenOfTheModernAge',
            fontSize: 48,
            color: Theme.of(context).primaryColor,
          ),
        ),
        if (isFirebaseUsable())
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: SizedBox(
              width: 400,
              child: TextFormField(
                cursorWidth: 1,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.nickname_hint,
                  contentPadding: const EdgeInsets.all(12.0),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
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
            ),
          ),
      ],
    );
  }

  Future getCurrentTheme() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      setState(() {
        darkmode = true;
      });
    } else {
      setState(() {
        darkmode = false;
      });
    }
  }

  Widget bottomBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(
                  right: 4.0,
                ),
                child: Icon(
                  Icons.apple,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 4.0,
                ),
                child: Text(
                  'IOS/MacOS',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
            color: Colors.grey[800],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(
                  right: 4.0,
                ),
                child: Icon(
                  Icons.android,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 4.0,
                ),
                child: Text(
                  'Android',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
            color: Colors.grey[800],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(
                  right: 4.0,
                ),
                child: Icon(
                  Icons.computer,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 4.0,
                ),
                child: Text(
                  'Windows/Linux/WEB',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget levelButton() {
    return IconButton(
      onPressed: () {
        setState(() {});
      },
      icon: const Icon(
        Icons.format_list_numbered,
      ),
    );
  }

  Widget darkModeButton() {
    return IconButton(
      onPressed: () {
        setState(
          () {
            darkmode
                ? AdaptiveTheme.of(context).setLight()
                : AdaptiveTheme.of(context).setDark();
            darkmode = !darkmode;
          },
        );
      },
      icon: Icon(
        darkmode ? Icons.wb_sunny : Icons.dark_mode,
      ),
    );
  }
}
