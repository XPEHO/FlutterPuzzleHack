class PuzzleState {
  late int complexity;
  late List<int> data;

  PuzzleState(this.complexity, {List<int>? values}) {
    data = values ?? generateValues();
  }

  List<int> generateValues() {
    return List<int>.generate(complexity * complexity, (i) => i);
  }
}
