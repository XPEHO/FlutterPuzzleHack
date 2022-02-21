import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PuzzleTitle extends StatelessWidget {
  const PuzzleTitle({Key? key, required this.isLandscape}) : super(key: key);
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.app_name,
          style: isLandscape
              ? const TextStyle(
                  fontFamily: "QueenOfTheModernAge",
                  fontSize: 24,
                  color: Colors.grey,
                )
              : const TextStyle(
                  fontFamily: "QueenOfTheModernAge",
                  fontSize: 24,
                  color: Colors.grey,
                ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          AppLocalizations.of(context)!.company_name,
          style: isLandscape
              ? TextStyle(
                  fontFamily: "QueenOfTheModernAge",
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                )
              : TextStyle(
                  fontFamily: "QueenOfTheModernAge",
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                ),
        ),
      ],
    );
  }
}
