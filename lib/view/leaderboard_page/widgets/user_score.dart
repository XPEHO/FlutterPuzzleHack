import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/providers/leaderboard_provider.dart';

class UserScore extends StatefulWidget {
  const UserScore({Key? key}) : super(key: key);

  @override
  State<UserScore> createState() => _UserScoreState();
}

class _UserScoreState extends State<UserScore> {
  final formKey = GlobalKey<FormState>();
  Future? _futureFetchUserScore;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureFetchUserScore,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Form(
              key: formKey,
              child: TextFormField(
                cursorWidth: 1,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.nickname_hint,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.search),
                  ),
                  contentPadding: const EdgeInsets.all(12.0),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600]!,
                ),
                onFieldSubmitted: (nickname) async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      _futureFetchUserScore =
                          LeaderboardProvider().fetchUserScore(nickname);
                    });
                  }
                },
                validator: (nickname) => _validateValue(nickname!),
              ),
            );
          } else {
            return Text(
              AppLocalizations.of(context)!.your_score(snapshot.data!),
            );
          }
        });
  }

  String? _validateValue(String nickname) {
    if (nickname.isEmpty) {
      return AppLocalizations.of(context)!.empty_nickname_error;
    }
    return null;
  }
}
