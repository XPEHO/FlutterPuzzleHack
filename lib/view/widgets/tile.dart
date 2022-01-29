import 'package:flutter/material.dart';
import 'package:puzzle/models/models.dart' as model;
import 'package:puzzle/view/widgets/widgets.dart';

class Tile extends StatelessWidget {
  final model.Tile tile;
  final Function(int) onTap;
  final bool gotImage;

  const Tile({
    Key? key,
    required this.tile,
    required this.onTap,
    required this.gotImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tile.value == 0) {
      return Container();
    }
    return GestureDetector(
      onTap: () => onTap(tile.value),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: 64.0,
        child: gotImage
            ? ImageTile(
                x: tile.targetX,
                y: tile.targetY,
              )
            : TextTile(
                text: '${tile.value}',
              ),
      ),
    );
  }
}
