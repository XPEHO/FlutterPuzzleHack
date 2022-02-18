import 'package:flutter/material.dart';
import 'package:puzzle/view/homepage/widgets/menu_button.dart';
import 'package:puzzle/view/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  static const String route = "/homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "XPEHO MOBILE",
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
                  child: MenuButton(
                    targetRoute: PuzzlePage.route,
                    text: AppLocalizations.of(context)!.play,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
