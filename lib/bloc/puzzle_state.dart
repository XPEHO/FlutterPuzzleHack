import 'dart:ui' as ui;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:puzzle/models/models.dart';

part 'puzzle_state.freezed.dart';

@freezed
class PuzzleState with _$PuzzleState {
  factory PuzzleState(Puzzle puzzle, {ui.Image? image}) = _PuzzleState;
}

extension PuzzleStateExtension on PuzzleState {
  int get complexity => puzzle.complexity;

  List<Tile> get data => puzzle.data;

  List<int> get values => puzzle.data.map((tile) => tile.value).toList();

  int indexOf(int value) => values.indexOf(value);
}
