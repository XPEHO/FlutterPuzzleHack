import 'package:puzzle/models/models.dart';

class PuzzleState {
  final Puzzle puzzle;

  PuzzleState(this.puzzle);

  int get complexity => puzzle.complexity;

  List<Tile> get data => puzzle.data;

  List<int> get values => puzzle.data.map((tile) => tile.value).toList();

  int indexOf(int value) => values.indexOf(value);
}
