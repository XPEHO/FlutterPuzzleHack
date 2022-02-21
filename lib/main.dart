import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/app/app.dart';
import 'package:puzzle/dependency_injection.dart';
import 'package:puzzle/services/shared.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isFirebaseUsable()) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  declareServices();
  runApp(const PuzzleApp());
}
