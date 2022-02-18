import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/services/audio_service.dart';
import 'package:puzzle/services/shared.dart';
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
  AudioService audioService = GetIt.I.get<AudioService>();

  @override
  void initState() {
    super.initState();
    _puzzleFocusNode = FocusNode();
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
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.white,
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return _buildPortrait(context, state);
            } else {
              return _buildLandscape(context, state);
            }
          },
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
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        _solve(context);
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
    context.read<PuzzleCubit>().shuffle();
    _puzzleFocusNode.requestFocus();
  }

  /// Solve the puzzle.
  void _solve(BuildContext context) {
    context.read<PuzzleCubit>().solve();
    _puzzleFocusNode.requestFocus();
  }

  /// Reset the puzzle.
  void _reset(BuildContext context) {
    context.read<PuzzleCubit>().reset();
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

  Widget _buildPortrait(BuildContext context, PuzzleState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(
              flex: 3,
              child: PuzzleTitle(),
            ),
            Flexible(
              flex: 10,
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => _shuffle(context),
                      icon: const Icon(Icons.shuffle),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.attach_file),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, PuzzleState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: PuzzleTitle(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Material(
                      color: Theme.of(context).primaryColor.withOpacity(.8),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () => _shuffle(context),
                                  icon: const Icon(
                                    Icons.shuffle,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.attach_file),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (!isMobile())
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.volume_down),
                                  Flexible(
                                    child: Slider(
                                      activeColor: Colors.indigoAccent,
                                      min: 0.0,
                                      max: 1.0,
                                      onChanged: (newRating) async {
                                        setState(() {
                                          audioService.volume = newRating;
                                        });
                                        audioService.updateVolume(newRating);
                                        _puzzleFocusNode.requestFocus();
                                      },
                                      value: audioService.volume,
                                    ),
                                  ),
                                  const Icon(Icons.volume_up),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset('assets/images/mascotte.jpeg'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
