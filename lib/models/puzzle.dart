import 'dart:collection';
import 'dart:math';

import 'package:puzzle/models/models.dart';

class Puzzle {
  bool isStarted = false;
  final int complexity;
  final List<Tile> data;

  Puzzle({
    required this.complexity,
    required this.data,
  });

  factory Puzzle.generate(int complexity) {
    final data = List<Tile>.generate(complexity * complexity, (index) {
      var value = index + 1;
      if (value == complexity * complexity) {
        return Tile(
          targetX: complexity - 1,
          targetY: complexity - 1,
          value: 0,
        );
      }
      return Tile(
        targetX: index % complexity,
        targetY: index ~/ complexity,
        value: value,
      );
    });

    return Puzzle(
      complexity: complexity,
      data: data,
    );
  }

  int getXof(Tile tile) => data.indexOf(tile) % complexity;

  int getYof(Tile tile) => data.indexOf(tile) ~/ complexity;

  int get error => data
      .map((tile) => tile.currentError(getXof(tile), getYof(tile)))
      .reduce((a, b) => a + b);

  /// perform a swap between two tiles
  Puzzle move(int value) {
    final newData = List<Tile>.from(data);

    /// find the tile with the value
    final tile = data.firstWhere((tile) => tile.value == value);
    final x = getXof(tile);
    final y = getYof(tile);

    /// find the empty tile to swap with
    final emptyTile = data.firstWhere((tile) => tile.value == 0);
    final emptyX = getXof(emptyTile);
    final emptyY = getYof(emptyTile);

    /// swap the tiles
    newData[x + y * complexity] = emptyTile;
    newData[emptyX + emptyY * complexity] = tile;

    return Puzzle(
      complexity: complexity,
      data: newData,
    );
  }

  bool canSwapLeft() {
    final int emptyIndex =
        data.indexOf(data.firstWhere((tile) => tile.value == 0));

    return (emptyIndex == 0 || (emptyIndex + 1) % complexity != 0);
  }

  Puzzle trySwapLeft() {
    final int emptyIndex =
        data.indexOf(data.firstWhere((tile) => tile.value == 0));

    if (emptyIndex > 0 && (emptyIndex + 1) % complexity == 0) {
      return this;
    }

    final int valueIndex = emptyIndex + 1;

    return move(data[valueIndex].value);
  }

  bool canSwapRight() {
    final int emptyIndex =
        data.indexOf(data.firstWhere((tile) => tile.value == 0));

    return emptyIndex != 0 && (emptyIndex + 1) % complexity != 1;
  }

  /// try to swap empty tile and the one on the left
  Puzzle trySwapRight() {
    final int emptyIndex =
        data.indexOf(data.firstWhere((tile) => tile.value == 0));

    if (emptyIndex == 0 || (emptyIndex + 1) % complexity == 1) {
      return this;
    }

    final int valueIndex = emptyIndex - 1;

    return move(data[valueIndex].value);
  }

  bool canSwapUp() {
    final int emptyIndex =
        data.indexOf(data.firstWhere((tile) => tile.value == 0));
    final int emptyRow = emptyIndex ~/ complexity;

    return emptyRow != complexity - 1;
  }

  /// try to swap empty tile and the one above
  Puzzle trySwapUp() {
    final int emptyIndex =
        data.indexOf(data.firstWhere((tile) => tile.value == 0));
    final int emptyRow = emptyIndex ~/ complexity;

    if (emptyRow == complexity - 1) {
      return this;
    }

    final int valueIndex = emptyIndex + complexity;

    return move(data[valueIndex].value);
  }

  bool canSwapDown() {
    final int emptyIndex =
        data.indexOf(data.firstWhere((tile) => tile.value == 0));
    final int emptyRow = emptyIndex ~/ complexity;

    return emptyRow != 0;
  }

  /// try to swap empty tile and the one below
  Puzzle trySwapDown() {
    final int emptyIndex =
        data.indexOf(data.firstWhere((tile) => tile.value == 0));
    final int emptyRow = emptyIndex ~/ complexity;

    if (emptyRow == 0) {
      return this;
    }

    final int valueIndex = emptyIndex - complexity;

    return move(data[valueIndex].value);
  }

  /// try to swap the tile with the empty tile
  Puzzle trySwap(int value) {
    final int emptyIndex = values.indexOf(0);

    // get empty row and column
    final int emptyRow = emptyIndex ~/ complexity;
    final int emptyCol = emptyIndex % complexity;

    // get value index
    final int valueIndex = values.indexOf(value);

    // get tile row and column
    final int tileRow = valueIndex ~/ complexity;
    final int tileCol = valueIndex % complexity;

    // check if the tile is in the same row or column
    if (emptyRow == tileRow || emptyCol == tileCol) {
      final int indexGap = (emptyIndex - valueIndex).abs();
      if ([1, complexity].contains(indexGap)) {
        return move(value);
      } else {
        return moveRowOrColumn(
          emptyIndex: emptyIndex,
          valueIndex: valueIndex,
          tileRow: tileRow,
          tileCol: tileCol,
          emptyRow: emptyRow,
          emptyCol: emptyCol,
        );
      }
    }
    return this;
  }

  /// move a full row or column depending on the empty tile position
  Puzzle moveRowOrColumn({
    required int emptyIndex,
    required int valueIndex,
    required int tileRow,
    required int tileCol,
    required int emptyRow,
    required int emptyCol,
  }) {
    final newData = List<Tile>.from(data);
    late int step;
    if (tileRow == emptyRow) {
      // move tiles on row between
      step = tileCol > emptyCol ? 1 : -1;
    } else if (tileCol == emptyCol) {
      // move tiles on column between
      step = tileRow > emptyRow ? complexity : -1 * complexity;
    }
    for (int i = emptyIndex; i != valueIndex; i += step) {
      final Tile temp = newData[i];
      newData[i] = newData[i + step];
      newData[i + step] = temp;
    }

    return Puzzle(complexity: complexity, data: newData);
  }

  Puzzle shuffle() {
    bool solvable = true;
    var shuffled = Puzzle(
      complexity: complexity,
      data: List<Tile>.from(data),
    );
    List<Puzzle> history = [shuffled];
    while (solvable) {
      var _moves = shuffled._possibleMoves();
      _moves.removeWhere((element) => history.contains(element));
      var _shuffled = _moves[Random().nextInt(_moves.length)];
      final solved = solve(_shuffled);
      solvable = solved.error == 0;
      if (solvable) {
        shuffled = _shuffled;
        history.add(shuffled);
      }
    }
    return shuffled;
  }

  List<Puzzle> _possibleMoves() => [
        if (canSwapLeft()) trySwapLeft(),
        if (canSwapRight()) trySwapRight(),
        if (canSwapUp()) trySwapUp(),
        if (canSwapDown()) trySwapDown(),
      ];

  /// Solve the puzzle
  /// To know if the puzzle is solved, we compute the "error" value.
  /// The error value is the sum of the errors of each tile.
  /// The error of a tile is the sum of the number of rows and columns between
  ///   current position and the goal position.
  /// The puzzle is 'solved' if the error is 0.
  static Puzzle solve(Puzzle puzzle) {
    Queue<Puzzle> unvisited = Queue.from([puzzle]);
    List<Puzzle> visited = [];
    Puzzle currentPuzzle = puzzle;

    while (unvisited.isNotEmpty &&
        currentPuzzle.error > 0 &&
        visited.length < 100) {
      currentPuzzle = unvisited.removeFirst();

      var moves = currentPuzzle._possibleMoves();

      moves.removeWhere((move) => visited.contains(move));
      moves.sort((a, b) => b.error.compareTo(a.error));
      for (var move in moves) {
        unvisited.addFirst(move);
      }
      visited.add(currentPuzzle);
    }
    // the puzzle is solved
    return currentPuzzle;
  }

  List<int> get values => data.map((tile) => tile.value).toList();

  @override
  int get hashCode => values.hashCode;

  @override
  String toString() {
    return '[${values.join(', ')}]';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Puzzle &&
          runtimeType == other.runtimeType &&
          toString() == other.toString();
}
