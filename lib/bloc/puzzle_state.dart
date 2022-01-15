class PuzzleState {
  final int complexity;
  late List<int> data;

  PuzzleState(this.complexity, {List<int>? values}) {
    data = values ?? List<int>.generate(complexity * complexity, (i) => i);
  }
}
