import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int value;
  final Function(int) onTap;

  const Tile({
    Key? key,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return Container();
    }
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: 64.0,
        child: Center(
          child: Text(
            '$value',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
