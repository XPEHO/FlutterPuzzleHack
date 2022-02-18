/// Class Tile
/// Differents position X & Y
/// The value for different tile
class Tile {
  int targetX;
  int targetY;
  int value;
  Tile({
    required this.targetY,
    required this.targetX,
    required this.value,
  });

  int currentError(int x, int y) {
    return (targetX - x).abs() + (targetY - y).abs();
  }
}
