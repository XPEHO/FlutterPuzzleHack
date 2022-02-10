import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/bloc/bloc.dart';

class ImageTile extends StatelessWidget {
  final int x;
  final int y;

  const ImageTile({
    Key? key,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PuzzleCubit>();
    final image = cubit.state.image;
    if (image == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final complexity = cubit.state.complexity;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LayoutBuilder(
        builder: (context, constraints) => CustomPaint(
          painter: _ImageTilePainter(
            x: x,
            y: y,
            image: image,
            complexity: complexity,
          ),
          child: const SizedBox(
            height: 100.0,
            width: 100.0,
          ),
        ),
      ),
    );
  }
}

class _ImageTilePainter extends CustomPainter {
  final int x;
  final int y;
  final ui.Image image;
  final int complexity;

  _ImageTilePainter({
    required this.x,
    required this.y,
    required this.image,
    required this.complexity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final ratio = 1 / complexity;

    final src = Rect.fromLTWH(
      x * image.width * ratio,
      y * image.height * ratio,
      image.width * ratio,
      image.height * ratio,
    );

    final dst = Rect.fromLTWH(
      0.0,
      0.0,
      size.width,
      size.height,
    );

    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
