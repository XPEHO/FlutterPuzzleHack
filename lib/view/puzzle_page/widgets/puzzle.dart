import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/models/models.dart' as model;
import 'package:puzzle/view/puzzle_page/widgets/widgets.dart';

typedef OnTileTapped = void Function(int tileValue);

class Puzzle extends StatefulWidget {
  final int size;
  final List<model.Tile> data;
  final OnTileTapped onTileTapped;

  const Puzzle({
    Key? key,
    required this.size,
    required this.data,
    required this.onTileTapped,
  }) : super(key: key);

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> with TickerProviderStateMixin {
  late AnimationController _openingAnimationController;
  late Animation<double> _openingAnimation;
  late bool _animationCompleted;

  @override
  void initState() {
    super.initState();
    _animationCompleted = false;

    _openingAnimationController = AnimationController(
      duration: Duration(seconds: _animationCompleted ? 0 : 2),
      vsync: this,
    )..forward().whenComplete(() => _animationCompleted = true);

    _openingAnimation = CurvedAnimation(
      parent: _openingAnimationController,
      curve: Curves.bounceOut,
    );
  }

  @override
  void dispose() {
    _openingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: widget.size,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        shrinkWrap: true,
        children: widget.data.map((value) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              reverseDuration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: ScaleTransition(
                  key: ValueKey<int>(value.value),
                  scale: _openingAnimation,
                  child: Tile(
                    tile: value,
                    onTap: (int number) {
                      setState(() {
                        widget.onTileTapped(number);
                      });
                    },
                    gotImage: context.read<PuzzleCubit>().state.image != null,
                  )));
        }).toList(),
      ),
    );
  }
}
