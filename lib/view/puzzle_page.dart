import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/services/audio_service.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
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
                      onTileTapped: (value) {
                        _trySwap(context, value);
                        _puzzleFocusNode.requestFocus();
                      },
                    ),
                  ),
                ),
                Padding(
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
                      Row(
                        children: [
                          const Icon(Icons.volume_down),
                          Slider(
                            activeColor: Colors.indigoAccent,
                            min: 0.0,
                            max: 1.0,
                            onChanged: (newRating) async {
                              setState(() {
                                audioService.volume = newRating;
                              });
                              audioService.updateVolume(newRating);
                            },
                            value: audioService.volume,
                          ),
                          const Icon(Icons.volume_up),
                        ],
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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<PuzzleCubit>().loadUiImage(pickedFile);
    }
  }
}
