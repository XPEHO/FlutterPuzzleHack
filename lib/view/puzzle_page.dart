import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/view/widgets/widgets.dart';
import 'package:shake/shake.dart';

/// Main page of the application.
/// Contains the puzzle and the controls.
class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  late ShakeDetector detector;
  late FocusNode _puzzleFocusNode;

  @override
  void initState() {
    super.initState();
    _puzzleFocusNode = FocusNode();
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        // is portrait
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        // is landscape
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PuzzleCubit, PuzzleState>(
      builder: (context, state) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Focus(
                    onKey: (_, event) => _onKeyEvent(
                      context,
                      event,
                    ),
                    autofocus: true,
                    canRequestFocus: true,
                    focusNode: _puzzleFocusNode,
                    child: Puzzle(
                      size: state.complexity,
                      data: state.data,
                      onTileTapped: (value) => _trySwap(context, value),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _shuffle(context),
                        icon: const Icon(Icons.shuffle),
                        label: Text(AppLocalizations.of(context)!.shuffle),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton.small(
                        child: const Icon(Icons.remove),
                        onPressed: () => _decreaseComplexity(context),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .complexity(state.complexity),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FloatingActionButton.small(
                        child: const Icon(Icons.add),
                        onPressed: () => _increaseComplexity(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Catch key events to perform actions on the puzzle.
  /// [context] is the current build context.
  /// [event] is the event.
  /// Returns KeyEventResult.handled if the event was handled.
  KeyEventResult _onKeyEvent(
    BuildContext context,
    RawKeyEvent event,
  ) {
    if (event.isKeyPressed(event.logicalKey)) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        context.read<PuzzleCubit>().trySwapLeft();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        context.read<PuzzleCubit>().trySwapRight();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        context.read<PuzzleCubit>().trySwapUp();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        context.read<PuzzleCubit>().trySwapDown();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        _shuffle(context);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.add) {
        context.read<PuzzleCubit>().increaseComplexity();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.minus) {
        context.read<PuzzleCubit>().decreaseComplexity();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  /// Try to swap the tile at the given position with the empty one.
  void _trySwap(BuildContext context, int tileValue) {
    context.read<PuzzleCubit>().trySwap(tileValue);
  }

  /// Shuffle the puzzle.
  void _shuffle(BuildContext context) {
    context.read<PuzzleCubit>().shuffle();
    _puzzleFocusNode.requestFocus();
  }

  void _increaseComplexity(BuildContext context) {
    context.read<PuzzleCubit>().increaseComplexity();
    _puzzleFocusNode.requestFocus();
  }

  void _decreaseComplexity(BuildContext context) {
    context.read<PuzzleCubit>().decreaseComplexity();
    _puzzleFocusNode.requestFocus();
  }
}
