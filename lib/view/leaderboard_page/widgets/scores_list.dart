import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoresList extends StatefulWidget {
  final Map<String, dynamic> scores;

  const ScoresList(this.scores, {Key? key}) : super(key: key);

  @override
  State<ScoresList> createState() => _ScoresListState();
}

class _ScoresListState extends State<ScoresList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.scores.keys.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 6.0, left: 12.0, bottom: 6.0),
                    child: Image.asset(
                      'assets/images/user_icon.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 6.0,
                          left: 12.0,
                        ),
                        child: Text(
                          widget.scores.keys.elementAt(index),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          bottom: 6.0,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.moves(
                              '${widget.scores.values.elementAt(index)}'),
                        ),
                      ),
                    ],
                  ),
                  Builder(builder: (context) {
                    if (index == 0) {
                      return Image.asset(
                        'assets/images/gold_metal_icon.png',
                        width: 50,
                        height: 50,
                      );
                    } else if (index == 1) {
                      return Image.asset(
                        'assets/images/silver_metal_icon.png',
                        width: 50,
                        height: 50,
                      );
                    } else if (index == 2) {
                      return Image.asset(
                        'assets/images/bronze_metal_icon.png',
                        width: 50,
                        height: 50,
                      );
                    } else {
                      return Image.asset(
                        'assets/images/looser_icon.png',
                        width: 50,
                        height: 50,
                      );
                    }
                  }),
                ],
              ),
              decoration: index == 0
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 3.0,
                        color: Colors.yellow,
                      ),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 3.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
