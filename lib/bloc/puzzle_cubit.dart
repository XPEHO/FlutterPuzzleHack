import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/models/models.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() : super(PuzzleState(Puzzle.generate(4)));

  void shuffle() {
    emitNewState(state.puzzle.shuffle());
  }

  void solve() {
    emitNewState(Puzzle.solve(state.puzzle));
  }

  /// try to swap the tile with the empty tile
  trySwap(int value) {
    emitNewState(state.puzzle.trySwap(value));
  }

  /// try to swap empty tile and the one on the right
  void trySwapLeft() {
    emitNewState(state.puzzle.trySwapLeft());
  }

  /// try to swap empty tile and the one on the left
  void trySwapRight() {
    emitNewState(state.puzzle.trySwapRight());
  }

  /// try to swap empty tile and the one above
  void trySwapUp() {
    emitNewState(state.puzzle.trySwapUp());
  }

  /// try to swap empty tile and the one below
  void trySwapDown() {
    emitNewState(state.puzzle.trySwapDown());
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
    emit(PuzzleState(newPuzzle));
  }
}
