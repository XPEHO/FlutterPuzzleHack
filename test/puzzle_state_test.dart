import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/models/models.dart';

main() {
  test('Puzzle state should generate data on the fly', () {
    // GIVEN
    const int size = 3;

    // WHEN
    final PuzzleState puzzleState = PuzzleState(Puzzle.generate(size));

    // THEN
    expect(puzzleState.complexity, size);
    expect(puzzleState.data.length, size * size);
  });
}
