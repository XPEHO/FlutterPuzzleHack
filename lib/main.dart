import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PuzzlePage(),
    );
  }
}

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final int _complexity = 4;

  late List<int> _data;

  @override
  void initState() {
    _data = List.generate(_complexity * _complexity, (index) => index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: _complexity,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  children: _data.map((value) => _buildTile(value)).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () => _shuffle(),
                child: const Text('Shuffle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _shuffle method
  void _shuffle() {
    setState(() {
      _data.shuffle();
    });
  }

  Widget _buildTile(int value) {
    if (value == 0) {
      return Container();
    }
    return GestureDetector(
      onTap: () => _trySwap(value),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: 64.0,
        child: Center(
          child: Text(
            '$value',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // try to swap the tile with the empty tile
  _trySwap(int value) {
    final int emptyIndex = _data.indexOf(0);

    // get empty row and column
    final int emptyRow = emptyIndex ~/ _complexity;
    final int emptyCol = emptyIndex % _complexity;

    // get value index
    final int valueIndex = _data.indexOf(value);

    // get tile row and column
    final int tileRow = valueIndex ~/ _complexity;
    final int tileCol = valueIndex % _complexity;

    // check if the tile is in the same row or column
    if (emptyRow == tileRow || emptyCol == tileCol) {
      final int indexGap = (emptyIndex - valueIndex).abs();
      if ([1, _complexity].contains(indexGap)) {
        _moveSingleTile(emptyIndex, valueIndex);
      } else {
        _moveRowOrColumn(
          emptyIndex: emptyIndex,
          valueIndex: valueIndex,
          emptyRow: emptyRow,
          emptyCol: emptyCol,
          tileRow: tileRow,
          tileCol: tileCol,
        );
      }
    }
  }

  void _moveSingleTile(int emptyIndex, int valueIndex) {
    setState(() {
      // swap the tiles
      final int temp = _data[emptyIndex];
      _data[emptyIndex] = _data[valueIndex];
      _data[valueIndex] = temp;
    });
  }

  // move the row or column
  _moveRowOrColumn({
    required int emptyIndex,
    required int valueIndex,
    required int tileRow,
    required int tileCol,
    required int emptyRow,
    required int emptyCol,
  }) {
    late int step;
    if (tileRow == emptyRow) {
      // move tiles on row between
      step = tileCol > emptyCol ? 1 : -1;
    } else if (tileCol == emptyCol) {
      // move tiles on column between
      step = tileRow > emptyRow ? _complexity : -1 * _complexity;
    }
    for (int i = emptyIndex; i != valueIndex; i += step) {
      setState(() {
        final int temp = _data[i];
        _data[i] = _data[i + step];
        _data[i + step] = temp;
      });
    }
  }
}
