import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/view/widgets/widgets.dart';

/// Main page of the application.
/// Contains the puzzle and the controls.
class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuzzleCubit, PuzzleState>(
      builder: (context, state) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Puzzle(
                    size: state.complexity,
                    data: state.data,
                    onTileTapped: (value) => _trySwap(context, value),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _shuffle(context),
                  child: Text(AppLocalizations.of(context)!.shuffle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _trySwap(BuildContext context, int tileValue) {
    context.read<PuzzleCubit>().trySwap(tileValue);
  }

  void _shuffle(BuildContext context) {
    context.read<PuzzleCubit>().shuffle();
  }
}
