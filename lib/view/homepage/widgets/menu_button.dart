import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuButton extends StatefulWidget {
  final String targetRoute;
  final String text;

  const MenuButton({required this.targetRoute, required this.text, Key? key})
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
        setState(() {
          _isElevated = !_isElevated;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isElevated = !_isElevated;
        });
        GoRouter.of(context).go(
          widget.targetRoute,
        );
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
          color: Colors.grey[300],
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
