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

class _PuzzleState extends State<Puzzle> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: widget.size,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: widget.data.map((value) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Tile(
            key: ValueKey<int>(value.value),
            tile: value,
            onTap: (int number) {
              setState(() {
                widget.onTileTapped(number);
              });
            },
            gotImage: context.read<PuzzleCubit>().state.image != null,
          ),
        );
      }).toList(),
    );
  }
}
