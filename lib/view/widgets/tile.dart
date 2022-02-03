import 'package:flutter/material.dart';
import 'package:puzzle/models/models.dart' as model;
import 'package:puzzle/view/widgets/widgets.dart';

class Tile extends StatefulWidget {
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
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scale = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tile.value == 0) {
      return Container();
    }
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTap: () {
            _controller.reset();
            widget.onTap(widget.tile.value);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: 64.0,
            child: widget.gotImage
                ? ImageTile(
                    x: widget.tile.targetX,
                    y: widget.tile.targetY,
                  )
                : TextTile(
                    text: '${widget.tile.value}',
                  ),
          ),
        ),
      ),
    );
  }
}
