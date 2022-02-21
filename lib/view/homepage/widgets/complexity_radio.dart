import 'package:flutter/material.dart';

typedef OnComplexitySelected = void Function(int? complexity);

class ComplexityRadio extends StatelessWidget {
  final String label;
  final int complexity;
  final int groupValue;
  final OnComplexitySelected onComplexitySelected;

  const ComplexityRadio({
    Key? key,
    required this.label,
    required this.complexity,
    required this.groupValue,
    required this.onComplexitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<int>(
          value: complexity,
          groupValue: groupValue,
          onChanged: onComplexitySelected,
        ),
        Text(label),
      ],
    );
  }
}
