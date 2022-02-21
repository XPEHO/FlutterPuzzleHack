import 'package:get_it/get_it.dart';
import 'package:puzzle/services/audio_service.dart';
import 'package:puzzle/services/leaderboard_service.dart';

GetIt getIt = GetIt.instance;

typedef ServiceDeclaration = void Function();

// ignore: prefer_function_declarations_over_variables
ServiceDeclaration declareServices = () {
  GetIt.I.registerSingleton(AudioService());
  GetIt.I.registerSingleton(LeaderboardService());
};
