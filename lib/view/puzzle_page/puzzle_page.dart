import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/providers/leaderboard_provider.dart';
import 'package:puzzle/services/audio_service.dart';
import 'package:puzzle/services/shared.dart';
import 'package:puzzle/theme/theme.dart';
import 'package:puzzle/view/puzzle_page/widgets/widgets.dart';
import 'package:shake/shake.dart';

/// Contains the puzzle and the controls.
class PuzzlePage extends StatefulWidget {
  static const String route = "/puzzlePage";

  const PuzzlePage({Key? key}) : super(key: key);

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  late ShakeDetector detector;
  late FocusNode _puzzleFocusNode;
  AudioService audioService = GetIt.I.get<AudioService>();

  @override
  void initState() {
    super.initState();
    _puzzleFocusNode = FocusNode();
    //Shake animations : start shuffle function
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      _shuffle(context);
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
      builder: (context, state) => OrientationBuilder(
        builder: (context, orientation) {
          if (state.puzzle.isSolved && state.moves > 0) {
            WidgetsBinding.instance?.addPostFrameCallback(
              (timeStamp) => _showVictoryScreen(context, state.moves),
            );
          }
          if (orientation == Orientation.portrait) {
            return _buildPortrait(context, state);
          } else {
            return _buildLandscape(context, state);
          }
        },
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
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        _reset(context);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.add) {
        _increaseComplexity(context);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.minus) {
        _decreaseComplexity(context);
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
    setState(() {
      context.read<PuzzleCubit>().shuffle();
      _puzzleFocusNode.requestFocus();
    });
  }

  /// Reset the puzzle.
  void _reset(BuildContext context) {
    context.read<PuzzleCubit>().reset();
    _puzzleFocusNode.requestFocus();
  }

  /// Up complexity of puzzle : Number of tile
  void _increaseComplexity(BuildContext context) {
    context.read<PuzzleCubit>().increaseComplexity();
    _puzzleFocusNode.requestFocus();
  }

  /// Decrease complexity of puzzle : Number of tile
  void _decreaseComplexity(BuildContext context) {
    context.read<PuzzleCubit>().decreaseComplexity();
    _puzzleFocusNode.requestFocus();
  }

  /// Load picture for the puzzle
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      if (kIsWeb) {
        context.read<PuzzleCubit>().loadUiImage(result.files.single.bytes);
      } else {
        final String path = result.files.single.path ?? '';
        final bytes = await File(path).readAsBytes();
        context.read<PuzzleCubit>().loadUiImage(bytes);
      }
    }
  }

  /// Build the portrait mode
  Widget _buildPortrait(BuildContext context, PuzzleState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: isMobile()
                    ? const EdgeInsets.symmetric(vertical: 16.0)
                    : const EdgeInsets.symmetric(vertical: 8.0),
                child: const PuzzleTitle(),
              ),
              Expanded(
                child: Focus(
                  onKey: (_, event) => _onKeyEvent(
                    context,
                    event,
                  ),
                  autofocus: true,
                  canRequestFocus: true,
                  focusNode: _puzzleFocusNode,
                  child: FractionallySizedBox(
                    widthFactor: isMobile() ? 1 : 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.moves(state.moves),
                          style: Theme.of(context).textTheme.headline5!,
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Flexible(
                          child: Puzzle(
                            size: state.complexity,
                            data: state.data,
                            onTileTapped: (value) {
                              _trySwap(context, value);
                              _puzzleFocusNode.requestFocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _shuffle(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(18),
                        elevation: 0,
                      ),
                      child: const Icon(
                        Icons.shuffle,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _reset(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(18),
                        elevation: 0,
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(18),
                        elevation: 0,
                      ),
                      child: const Icon(
                        Icons.attach_file,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          audioService.volume == 1
                              ? audioService.updateVolume(0)
                              : audioService.updateVolume(1);
                        });
                        _puzzleFocusNode.requestFocus();
                      },
                      style: ElevatedButton.styleFrom(
                        primary:
                            audioService.volume == 1 ? xpehoGreen : Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(18),
                        elevation: 0,
                      ),
                      child: Icon(
                        audioService.volume == 1
                            ? Icons.volume_up
                            : Icons.volume_mute,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the landscape mode
  Widget _buildLandscape(BuildContext context, PuzzleState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 24,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _shuffle(context),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            elevation: 0,
                          ),
                          child: const Icon(
                            Icons.shuffle,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _reset(context),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            elevation: 0,
                          ),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _pickImage,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            elevation: 0,
                          ),
                          child: const Icon(
                            Icons.attach_file,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              audioService.volume == 1
                                  ? audioService.updateVolume(0)
                                  : audioService.updateVolume(1);
                            });
                            _puzzleFocusNode.requestFocus();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: audioService.volume == 1
                                ? xpehoGreen
                                : Colors.grey,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            elevation: 0,
                          ),
                          child: Icon(
                            audioService.volume == 1
                                ? Icons.volume_up
                                : Icons.volume_mute,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: PuzzleTitle(),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.moves(state.moves),
                    style: Theme.of(context).textTheme.headline5!,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
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
                      onTileTapped: (value) {
                        _trySwap(context, value);
                        _puzzleFocusNode.requestFocus();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/images/mascotte.jpeg'),
            ),
          ),
        ],
      ),
    );
  }

  /// Show a dialog to the user to celebrate victory
  Future<void> _showVictoryScreen(BuildContext context, int moves) async {
    if (isFirebaseUsable()) {
      LeaderboardProvider().updateUserScore(moves);
    }
    await showAnimatedDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => const AlertDialog(
        content: Victory(),
      ),
      animationType: DialogTransitionType.rotate3D,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 3),
    );
    _reset(context);
  }
}
