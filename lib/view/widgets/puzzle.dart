import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/models/models.dart' as model;
import 'package:puzzle/view/widgets/widgets.dart';

typedef OnTileTapped = void Function(int tileValue);

class Puzzle extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: size,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: data.map((value) {
        return Tile(
          tile: value,
          onTap: onTileTapped,
          gotImage: context.read<PuzzleCubit>().state.image != null,
        );
      }).toList(),
    );
  }
}
