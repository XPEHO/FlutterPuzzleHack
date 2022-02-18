import 'package:flutter/material.dart';
import 'package:puzzle/models/models.dart' as model;
import 'package:puzzle/view/puzzle_page/widgets/widgets.dart';

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
  late AnimationController _hoverAnimationController;
  late Animation<double> _hoverAnimation;
  late AnimationController _openingAnimationController;
  late Animation<double> _openingAnimation;
  double opacityLevel = 1.0;

  @override
  void initState() {
    super.initState();

    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _hoverAnimationController,
        curve: const Interval(0, 1),
      ),
    );

    _openingAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _openingAnimation = CurvedAnimation(
      parent: _openingAnimationController,
      curve: Curves.bounceOut,
    );
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    _openingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tile.value == 0) {
      return Container();
    }
    return MouseRegion(
      onEnter: (_) => _hoverAnimationController.forward(),
      onExit: (_) => _hoverAnimationController.reverse(),
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _hoverAnimation,
        child: GestureDetector(
          onTap: () {
            _hoverAnimationController.reset();
            widget.onTap(widget.tile.value);
          },
          child: ScaleTransition(
            scale: _openingAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
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
      ),
    );
  }
}
