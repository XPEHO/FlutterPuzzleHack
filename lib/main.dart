import 'package:flutter/material.dart';
import 'package:puzzle/app/app.dart';
import 'package:puzzle/dependency_injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  declareServices();
  runApp(const PuzzleApp());
}
