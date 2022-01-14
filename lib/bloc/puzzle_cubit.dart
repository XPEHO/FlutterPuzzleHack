import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/bloc/bloc.dart';

class PuzzleCubit extends Cubit<PuzzleState> {

  PuzzleCubit() : super(PuzzleState(4));

  // _shuffle method
  void shuffle() {
    state.data.shuffle();
    emit(PuzzleState(state.complexity, values: state.data));
  }

  // try to swap the tile with the empty tile
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

  void _moveSingleTile(int emptyIndex, int valueIndex) {
    // swap the tiles
    final int temp = state.data[emptyIndex];
    state.data[emptyIndex] = state.data[valueIndex];
    state.data[valueIndex] = temp;
    emit(PuzzleState(state.complexity, values: state.data));
  }

  // move the row or column
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

}