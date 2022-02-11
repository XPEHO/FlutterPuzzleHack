import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/models/models.dart';
import 'package:puzzle/services/audio_service.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() : super(PuzzleState(Puzzle.generate(4)));
  AudioService audioService = GetIt.I.get<AudioService>();

  void shuffle() {
    emitNewState(state.puzzle.shuffle());
  }

  void solve() {
    emitNewState(Puzzle.solve(state.puzzle));
  }

  /// try to swap the tile with the empty tile
  trySwap(int value) {
    if (state.puzzle.canSwap(value)) {
      audioService.play("sounds/Success.mp3", isLocal: true);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }
    emitNewState(state.puzzle.trySwap(value));
  }

  /// try to swap empty tile and the one on the right
  void trySwapLeft() {
    if (state.puzzle.canSwapLeft()) {
      audioService.play("sounds/Success.mp3", isLocal: true);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }

    emitNewState(state.puzzle.trySwapLeft());
  }

  /// try to swap empty tile and the one on the left
  void trySwapRight() {
    if (state.puzzle.canSwapRight()) {
      audioService.play("sounds/Success.mp3", isLocal: true);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }

    emitNewState(state.puzzle.trySwapRight());
  }

  /// try to swap empty tile and the one above
  void trySwapUp() {
    if (state.puzzle.canSwapUp()) {
      audioService.play("sounds/Success.mp3", isLocal: true);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }

    emitNewState(state.puzzle.trySwapUp());
  }

  /// try to swap empty tile and the one below
  void trySwapDown() {
    if (state.puzzle.canSwapDown()) {
      audioService.play("sounds/Success.mp3", isLocal: true);
    } else {
      audioService.play("sounds/Error.mp3", isLocal: true);
    }

    emitNewState(state.puzzle.trySwapDown());
  }

  /// reset the puzzle
  void reset() {
    emitNewState(Puzzle.generate(state.puzzle.complexity));
  }

  /// increase complexity of the puzzle
  void increaseComplexity() {
    emitNewState(Puzzle.generate(state.puzzle.complexity + 1));
  }

  /// decrease complexity of the puzzle
  void decreaseComplexity() {
    emitNewState(Puzzle.generate(state.puzzle.complexity - 1));
  }

  void emitNewState(Puzzle newPuzzle) {
    emit(state.copyWith(puzzle: newPuzzle));
  }

  Future<void> loadUiImage(Uint8List? bytes) async {
    if (bytes == null) return;
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    emit(state.copyWith(image: frame.image));
  }
}
