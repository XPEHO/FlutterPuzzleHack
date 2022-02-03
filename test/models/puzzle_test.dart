import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:puzzle/models/models.dart';
import 'package:puzzle/services/audio_service.dart';

class AudioServiceMock extends Mock implements AudioService {}

main() {
  WidgetsFlutterBinding.ensureInitialized();

  final _audioService = AudioServiceMock();
  GetIt.I.registerSingleton<AudioService>(_audioService);

  test('Puzzle factory', () async {
    // GIVEN
    const complexity = 3;

    // WHEN
    var puzzle = Puzzle.generate(complexity);

    // THEN
    expect(puzzle.complexity, complexity);
    expect(puzzle.data.length, complexity * complexity);
    var zeroTile = puzzle.data.firstWhere((tile) => tile.value == 0);
    expect(puzzle.getXof(zeroTile), 2);
    expect(puzzle.getYof(zeroTile), 2);
    expect(zeroTile.targetX, 2);
    expect(zeroTile.targetY, 2);
    var oneTile = puzzle.data.firstWhere((tile) => tile.value == 1);
    expect(puzzle.getXof(oneTile), 0);
    expect(puzzle.getYof(oneTile), 0);
    expect(oneTile.targetX, 0);
    expect(oneTile.targetY, 0);

    var eightTile = puzzle.data.firstWhere((tile) => tile.value == 8);
    expect(puzzle.getXof(eightTile), 1);
    expect(puzzle.getYof(eightTile), 2);
  });

  group('Puzzle moves', () {
    test('move left', () {
      // GIVEN
      when(_audioService.play("assets/sounds/Succes.mp3")).thenReturn(null);
      when(_audioService.play("assets/sounds/Error.mp3")).thenReturn(null);
      var puzzle = Puzzle.generate(3);
      puzzle.trySwapRight();

      // WHEN
      var newPuzzle = puzzle.trySwapLeft();

      // THEN
      expect(newPuzzle.data.map((e) => e.value), [1, 2, 3, 4, 5, 6, 7, 8, 0]);
    });

    test('move right', () {
      // GIVEN
      when(_audioService.play("assets/sounds/Succes.mp3")).thenReturn(null);
      when(_audioService.play("assets/sounds/Error.mp3")).thenReturn(null);
      var puzzle = Puzzle.generate(3);
      // first swipe left to be able to swipe right
      puzzle = puzzle.trySwapLeft();

      // WHEN
      var newPuzzle = puzzle.trySwapRight();

      // THEN
      expect(newPuzzle.data.map((e) => e.value), [1, 2, 3, 4, 5, 6, 7, 0, 8]);
    });

    test('move up', () {
      // GIVEN
      when(_audioService.play("assets/sounds/Succes.mp3")).thenReturn(null);
      when(_audioService.play("assets/sounds/Error.mp3")).thenReturn(null);
      var puzzle = Puzzle.generate(3);
      puzzle.trySwapDown();

      // WHEN
      var newPuzzle = puzzle.trySwapUp();

      // THEN
      expect(newPuzzle.data.map((e) => e.value), [1, 2, 3, 4, 5, 6, 7, 8, 0]);
    });

    test('move down', () {
      // GIVEN
      when(_audioService.play("assets/sounds/Succes.mp3")).thenReturn(null);
      when(_audioService.play("assets/sounds/Error.mp3")).thenReturn(null);
      var puzzle = Puzzle.generate(3);
      // first swipe up to be able to swipe down
      puzzle = puzzle.trySwapUp();

      // WHEN
      var newPuzzle = puzzle.trySwapDown();

      // THEN
      expect(newPuzzle.data.map((e) => e.value), [1, 2, 3, 4, 5, 0, 7, 8, 6]);
    });
  });

  // Group error
  group('Error', () {
    test('Generated puzzle should have no error', () {
      // GIVEN
      var puzzle = Puzzle.generate(3);

      // WHEN
      var error = puzzle.error;

      // THEN
      expect(error, 0);
    });
    test('shuffled puzzle should have error', () {
      // GIVEN
      var puzzle = Puzzle.generate(3);
      puzzle = puzzle.shuffle();

      // WHEN
      var error = puzzle.error;

      // THEN
      expect(error > 0, true);
    });
    test('manual puzzle should have no error', () {
      // GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
        Tile(value: 0, targetX: 2, targetY: 2),
      ]);

      // WHEN
      var error = puzzle.error;

      // THEN
      expect(error == 0, true);
    });
    test('one error', () {
      // GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);

      // WHEN
      var error = puzzle.error;

      // THEN
      expect(error, 2);
    });
  });

  group('can swap', () {
    test('can swap up true', () {
      //GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);

      //WHEN
      bool canSwap = puzzle.canSwapUp();

      //THEN
      expect(canSwap, true);
    });
    test('can swap up false', () {
      //GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
        Tile(value: 0, targetX: 2, targetY: 2),
      ]);

      //WHEN
      bool canSwap = puzzle.canSwapUp();

      //THEN
      expect(canSwap, false);
    });
    test('can swap down true', () {
      //GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
        Tile(value: 0, targetX: 2, targetY: 2),
      ]);

      //WHEN
      bool canSwap = puzzle.canSwapDown();

      //THEN
      expect(canSwap, true);
    });
    test('can swap down false', () {
      //GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);

      //WHEN
      bool canSwap = puzzle.canSwapDown();

      //THEN
      expect(canSwap, false);
    });
    test('can swap left true', () {
      //GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);

      //WHEN
      bool canSwap = puzzle.canSwapLeft();

      //THEN
      expect(canSwap, true);
    });
    test('can swap left false', () {
      //GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
        Tile(value: 0, targetX: 2, targetY: 2),
      ]);

      //WHEN
      bool canSwap = puzzle.canSwapLeft();

      //THEN
      expect(canSwap, false);
    });
    test('can swap right true', () {
      //GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
        Tile(value: 0, targetX: 2, targetY: 2),
      ]);

      //WHEN
      bool canSwap = puzzle.canSwapRight();

      //THEN
      expect(canSwap, true);
    });
    test('can swap right false', () {
      //GIVEN
      Puzzle puzzle = Puzzle(complexity: 3, data: [
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);

      //WHEN
      bool canSwap = puzzle.canSwapRight();

      //THEN
      expect(canSwap, false);
    });
  });

  // Group solved
  group('Solved', () {
    test('Generated puzzle should be solvable', () {
      // GIVEN
      var puzzle = Puzzle.generate(9);
      puzzle = puzzle.shuffle();

      // WHEN
      var solved = Puzzle.solve(puzzle);

      // THEN
      expect(solved.error, 0);
    });
  });

  group('equal operator', () {
    test('equal true', () {
      // GIVEN
      Puzzle puzzleA = Puzzle(complexity: 3, data: [
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);
      Puzzle puzzleB = Puzzle(complexity: 3, data: [
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);

      // WHEN
      bool equal = puzzleA == puzzleB;

      // THEN
      expect(equal, true);
    });

    test('contains true', () {
      // GIVEN
      Puzzle puzzleA = Puzzle(complexity: 3, data: [
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);
      Puzzle puzzleB = Puzzle(complexity: 3, data: [
        Tile(value: 0, targetX: 2, targetY: 2),
        Tile(value: 1, targetX: 0, targetY: 0),
        Tile(value: 2, targetX: 1, targetY: 0),
        Tile(value: 3, targetX: 2, targetY: 0),
        Tile(value: 4, targetX: 0, targetY: 1),
        Tile(value: 5, targetX: 1, targetY: 1),
        Tile(value: 6, targetX: 2, targetY: 1),
        Tile(value: 7, targetX: 0, targetY: 2),
        Tile(value: 8, targetX: 1, targetY: 2),
      ]);

      // WHEN
      bool contains = [puzzleA].contains(puzzleB);

      // THEN
      expect(contains, true);
    });
  });
}
