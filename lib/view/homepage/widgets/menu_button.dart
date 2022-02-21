import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  final Function redirection;
  final String text;
  final bool isClickable;

  const MenuButton(
      {required this.redirection,
      required this.text,
      required this.isClickable,
      Key? key})
      : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _isElevated = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.isClickable) {
          setState(() {
            _isElevated = !_isElevated;
          });
        }
      },
      onTapUp: (_) {
        if (widget.isClickable) {
          setState(() {
            _isElevated = !_isElevated;
          });
          widget.redirection();
        }
      },
      child: AnimatedContainer(
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        duration: const Duration(milliseconds: 200),
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: widget.isClickable ? Colors.grey[300] : Colors.grey[700],
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isElevated
              ? [
                  BoxShadow(
                    color: Colors.grey[500]!,
                    offset: const Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
