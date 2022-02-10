import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            GoRouter.of(context).go(
              PuzzlePage.route,
            );
          },
          child: Text(
            AppLocalizations.of(context)!.play,
          ),
        )
      ],
    );
  }
}
