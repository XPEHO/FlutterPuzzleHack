class UnsolvablePuzzleError implements Exception {
  final String message;

  UnsolvablePuzzleError(this.message);

  @override
  String toString() => message;
}
