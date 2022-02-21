import 'package:flutter/material.dart';

class ScoresList extends StatefulWidget {
  final Map<String, dynamic> scores;

  const ScoresList(this.scores, {Key? key}) : super(key: key);

  @override
  State<ScoresList> createState() => _ScoresListState();
}

class _ScoresListState extends State<ScoresList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.scores.keys.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text(
                "${widget.scores.keys.elementAt(index)}: ${widget.scores.values.elementAt(index)}",
              ),
            ],
          );
        },
      ),
    );
  }
}
