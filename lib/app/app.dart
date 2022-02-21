import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/bloc/bloc.dart';
import 'package:puzzle/theme/theme.dart';
import 'package:puzzle/view/view.dart';
import 'package:go_router/go_router.dart';

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final _router = _buildRouter();

        return MaterialApp.router(
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.app_name,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
              primarySwatch: xpehoGreen,
              textTheme: GoogleFonts.aBeeZeeTextTheme()),
        );
      },
    );
  }

  GoRouter _buildRouter() => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            redirect: (state) {
              return HomePage.route;
            },
          ),
          GoRoute(
            path: HomePage.route,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionDuration: Duration.zero,
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) =>
                  FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
          GoRoute(
            path: PuzzlePage.route,
            builder: (context, state) => BlocProvider(
              create: (_) => PuzzleCubit(),
              child: const PuzzlePage(),
            ),
          ),
          GoRoute(
            path: LeaderboardPage.route,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const LeaderboardPage(),
              transitionDuration: Duration.zero,
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) =>
                  FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
        ],
      );
}
