import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTile extends StatelessWidget {
  final String text;

  const TextTile({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
