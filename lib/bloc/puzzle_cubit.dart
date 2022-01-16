import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/bloc/bloc.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() : super(PuzzleState(4));

  /// _shuffle method
  void shuffle() {
    state.data.shuffle();
    emit(PuzzleState(state.complexity, values: state.data));
  }

  /// try to swap the tile with the empty tile
  trySwap(int value) {
    final int emptyIndex = state.data.indexOf(0);

    // get empty row and column
    final int emptyRow = emptyIndex ~/ state.complexity;
    final int emptyCol = emptyIndex % state.complexity;

    // get value index
    final int valueIndex = state.data.indexOf(value);

    // get tile row and column
    final int tileRow = valueIndex ~/ state.complexity;
    final int tileCol = valueIndex % state.complexity;

    // check if the tile is in the same row or column
    if (emptyRow == tileRow || emptyCol == tileCol) {
      final int indexGap = (emptyIndex - valueIndex).abs();
      if ([1, state.complexity].contains(indexGap)) {
        _moveSingleTile(emptyIndex, valueIndex);
      } else {
        _moveRowOrColumn(
          emptyIndex: emptyIndex,
          valueIndex: valueIndex,
          emptyRow: emptyRow,
          emptyCol: emptyCol,
          tileRow: tileRow,
          tileCol: tileCol,
        );
      }
    }
  }

  /// perform a swap between two tiles
  void _moveSingleTile(int emptyIndex, int valueIndex) {
    // swap the tiles
    final int temp = state.data[emptyIndex];
    state.data[emptyIndex] = state.data[valueIndex];
    state.data[valueIndex] = temp;
    emit(PuzzleState(state.complexity, values: state.data));
  }

  /// move a full row or column depending on the empty tile position
  _moveRowOrColumn({
    required int emptyIndex,
    required int valueIndex,
    required int tileRow,
    required int tileCol,
    required int emptyRow,
    required int emptyCol,
  }) {
    late int step;
    if (tileRow == emptyRow) {
      // move tiles on row between
      step = tileCol > emptyCol ? 1 : -1;
    } else if (tileCol == emptyCol) {
      // move tiles on column between
      step = tileRow > emptyRow ? state.complexity : -1 * state.complexity;
    }
    for (int i = emptyIndex; i != valueIndex; i += step) {
      final int temp = state.data[i];
      state.data[i] = state.data[i + step];
      state.data[i + step] = temp;
    }
    emit(PuzzleState(state.complexity, values: state.data));
  }

  /// try to swap empty tile and the one on the right
  void trySwapLeft() {
    final int emptyIndex = state.data.indexOf(0);

    if (emptyIndex > 0 && (emptyIndex + 1) % state.complexity == 0) {
      return;
    }

    final int valueIndex = emptyIndex + 1;

    _moveSingleTile(emptyIndex, valueIndex);
  }

  /// try to swap empty tile and the one on the left
  void trySwapRight() {
    final int emptyIndex = state.data.indexOf(0);

    if (emptyIndex == 0 || (emptyIndex + 1) % state.complexity == 1) {
      return;
    }

    final int valueIndex = emptyIndex - 1;

    _moveSingleTile(emptyIndex, valueIndex);
  }

  /// try to swap empty tile and the one above
  void trySwapUp() {
    final int emptyIndex = state.data.indexOf(0);
    final int emptyRow = emptyIndex ~/ state.complexity;

    if (emptyRow == state.complexity - 1) {
      return;
    }

    final int valueIndex = emptyIndex + state.complexity;

    _moveSingleTile(emptyIndex, valueIndex);
  }

  /// try to swap empty tile and the one below
  void trySwapDown() {
    final int emptyIndex = state.data.indexOf(0);
    final int emptyRow = emptyIndex ~/ state.complexity;

    if (emptyRow == 0) {
      return;
    }

    final int valueIndex = emptyIndex - state.complexity;

    _moveSingleTile(emptyIndex, valueIndex);
  }

  /// increase complexity of the puzzle
  void increaseComplexity() {
    state.complexity++;
    state.data = state.generateValues();
    emit(PuzzleState(state.complexity, values: state.data));
  }

  /// decrease complexity of the puzzle
  void decreaseComplexity() {
    state.complexity--;
    state.data = state.generateValues();
    emit(PuzzleState(state.complexity, values: state.data));
  }
}
