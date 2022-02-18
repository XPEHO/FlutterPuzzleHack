import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Victory widget to celebrate victory with user.
class Victory extends StatelessWidget {
  const Victory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(context)!.victory_title,
            style: Theme.of(context).textTheme.headline2!,
          ),
        ),
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.restart_btn),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
