import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/models/models.dart';
import 'package:puzzle/services/audio_service.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() : super(PuzzleState(Puzzle.generate(3)..shuffle())) {
    channel.setMethodCallHandler((call) async {
      debugPrint(
          "handling new call from native ${call.method} with arguments ${call.arguments}");
      // Receive data from Native
      switch (call.method) {
        case "sendMovesToFlutter":
          var data = call.arguments as String;
          debugPrint("received moves from native: $data");
          emitNewState(state.puzzle, int.parse(data), sendToNative: false);
          break;
        case "sendPuzzleToFlutter":
          var data = call.arguments as String;
          debugPrint("received new puzzle state from native $data");
          List<String> values = data.split(",");
          debugPrint("values: $values");
          emitNewState(
              Puzzle(
                complexity: state.puzzle.complexity,
                data: values
                    .map((v) => Puzzle.generateTile(
                        int.parse(v) - 1, state.puzzle.complexity))
                    .toList(),
              ),
              state.moves,
              sendToNative: false);
          break;
        default:
          break;
      }
    });
  }
  AudioService audioService = GetIt.I.get<AudioService>();
  final channel = const MethodChannel('fr.xpeho.puzzle');

  void shuffle() {
    emitNewState(state.puzzle.shuffle(), 0);
  }

  /// try to swap the tile with the empty tile
  trySwap(int value) {
    if (kIsWeb || !Platform.isIOS) {
      if (state.puzzle.canSwap(value)) {
        audioService.play("sounds/Success.mp3", isLocal: true);
      } else {
        audioService.play("sounds/Error.mp3", isLocal: true);
      }
    }
    emitNewState(state.puzzle.trySwap(value), state.moves + 1);
  }

  /// try to swap empty tile and the one on the right
  void trySwapLeft() {
    if (state.puzzle.canSwapLeft()) {
      audioService.play("sounds/Success.mp3", isLocal: true);
      emitNewState(state.puzzle.trySwapLeft(), state.moves + 1);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }
  }

  /// try to swap empty tile and the one on the left
  void trySwapRight() {
    if (state.puzzle.canSwapRight()) {
      audioService.play("sounds/Success.mp3", isLocal: true);
      emitNewState(state.puzzle.trySwapRight(), state.moves + 1);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }
  }

  /// try to swap empty tile and the one above
  void trySwapUp() {
    if (state.puzzle.canSwapUp()) {
      audioService.play("sounds/Success.mp3", isLocal: true);
      emitNewState(state.puzzle.trySwapUp(), state.moves + 1);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }
  }

  /// try to swap empty tile and the one below
  void trySwapDown() {
    if (state.puzzle.canSwapDown()) {
      audioService.play("sounds/Success.mp3", isLocal: true);
      emitNewState(state.puzzle.trySwapDown(), state.moves + 1);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }
  }

  /// reset the puzzle
  void reset() {
    emitNewState(Puzzle.generate(state.puzzle.complexity), 0);
  }

  /// increase complexity of the puzzle
  void increaseComplexity() {
    emitNewState(Puzzle.generate(state.puzzle.complexity + 1), 0);
  }

  /// decrease complexity of the puzzle
  void decreaseComplexity() {
    emitNewState(Puzzle.generate(state.puzzle.complexity - 1), 0);
  }

  void emitNewState(Puzzle newPuzzle, int moves, {bool sendToNative = true}) {
    emit(state.copyWith(puzzle: newPuzzle, moves: moves));
    debugPrint("Sending puzzle to native: ${newPuzzle.values.join(",")}");
    if (sendToNative) {
      channel.invokeMethod("puzzleToWatch", {
        "method": "sendPuzzleToNative",
        "puzzle": newPuzzle.values.join(",")
      });
      channel.invokeMethod("movesToWatch",
          {"method": "sendMovesToNative", "moves": moves.toString()});
    }
  }

  Future<void> loadUiImage(Uint8List? bytes) async {
    if (bytes == null) return;
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    emit(state.copyWith(image: frame.image));
  }
}
