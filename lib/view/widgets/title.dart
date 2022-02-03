import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PuzzleTitle extends StatelessWidget {
  const PuzzleTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.app_name,
            style: Theme.of(context).textTheme.headline2),
        Text(
          AppLocalizations.of(context)!.team_name,
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}
