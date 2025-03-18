import 'package:flutter/material.dart';

void main() {
  runApp(const QueensGameApp());
}

class QueensGameApp extends StatelessWidget {
  const QueensGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Queens Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QueensGame(),
    );
  }
}

class QueensGame extends StatefulWidget {
  const QueensGame({super.key});

  @override
  _QueensGameState createState() => _QueensGameState();
}

class _QueensGameState extends State<QueensGame> {
  final int gridSize = 9; // 9x9'lik bir oyun tahtası
  List<List<int>> board =
      List.generate(9, (_) => List.filled(9, 0)); // 0: boş, 1: çarpı, 2: taç
  List<List<List<Color>>> templates = []; // Renk şablonları
  int currentTemplateIndex = 0; // Geçerli şablon indeksi
  bool gameWon = false; // Oyunun kazanılıp kazanılmadığını takip et

  int gameTemplateIndex = 0;

  List<Map<String, dynamic>> maps = [
    {
      "name": "Map n° 21",
      "caseNumber": 9,
      "colorGrid": [
        [2, 0, 1, 1, 1, 1, 1, 1, 1],
        [2, 2, 2, 1, 1, 1, 1, 3, 3],
        [4, 2, 2, 1, 1, 1, 3, 3, 3],
        [4, 4, 4, 4, 3, 3, 3, 3, 3],
        [6, 6, 6, 4, 4, 3, 3, 3, 5],
        [6, 6, 6, 4, 4, 3, 3, 5, 5],
        [6, 6, 6, 8, 8, 3, 3, 5, 5],
        [6, 8, 8, 8, 8, 8, 8, 7, 5],
        [6, 8, 8, 8, 8, 8, 8, 8, 5]
      ]
    },
    {
      "name": "Map n° 22",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 3, 3, 1, 1, 1, 1, 1],
        [0, 0, 3, 3, 1, 1, 3, 3, 2],
        [3, 3, 3, 3, 3, 3, 3, 2, 2],
        [3, 3, 3, 3, 3, 3, 3, 3, 4],
        [3, 3, 3, 3, 3, 3, 3, 6, 4],
        [3, 3, 3, 5, 5, 6, 6, 6, 6],
        [7, 7, 7, 7, 7, 6, 6, 6, 6],
        [7, 7, 7, 7, 7, 8, 6, 6, 6],
        [7, 7, 7, 7, 7, 8, 6, 6, 6]
      ]
    },
    {
      "name": "Map n° 6",
      "caseNumber": 9,
      "colorGrid": [
        [8, 7, 2, 2, 2, 2, 3, 3, 3],
        [8, 7, 2, 7, 7, 7, 7, 7, 3],
        [8, 7, 2, 7, 5, 5, 5, 7, 3],
        [8, 7, 6, 7, 5, 7, 5, 7, 3],
        [1, 7, 6, 7, 5, 7, 0, 7, 3],
        [1, 7, 6, 7, 7, 7, 0, 7, 3],
        [1, 7, 6, 6, 0, 0, 0, 7, 4],
        [1, 7, 7, 7, 7, 7, 7, 7, 4],
        [1, 1, 1, 4, 4, 4, 4, 4, 4]
      ]
    },
    {
      "name": "Map n° 17",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 2, 2, 0, 4, 0],
        [4, 4, 4, 3, 2, 2, 2, 4, 4],
        [4, 4, 4, 3, 3, 4, 4, 4, 4],
        [4, 4, 4, 4, 4, 4, 4, 4, 4],
        [6, 6, 6, 4, 5, 5, 4, 4, 4],
        [6, 6, 8, 4, 5, 5, 4, 4, 4],
        [8, 8, 8, 8, 8, 7, 4, 4, 4],
        [8, 8, 8, 8, 8, 8, 4, 4, 4]
      ]
    },
    {
      "name": "Map n° 18",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 2, 2, 2, 0, 0, 0],
        [1, 1, 1, 2, 2, 2, 0, 0, 0],
        [1, 1, 1, 2, 2, 3, 3, 0, 0],
        [1, 4, 1, 1, 1, 3, 3, 6, 0],
        [1, 4, 1, 1, 1, 5, 5, 6, 6],
        [1, 4, 7, 7, 7, 6, 6, 6, 6],
        [7, 7, 7, 7, 7, 6, 6, 6, 6],
        [7, 7, 7, 7, 7, 7, 7, 8, 8]
      ]
    },
    {
      "name": "Map n° 19",
      "caseNumber": 9,
      "colorGrid": [
        [5, 1, 1, 3, 3, 0, 0, 0, 0],
        [5, 1, 1, 3, 3, 3, 0, 0, 0],
        [5, 5, 5, 3, 3, 0, 0, 2, 0],
        [5, 5, 5, 3, 3, 0, 0, 4, 4],
        [5, 5, 5, 5, 4, 4, 4, 4, 4],
        [5, 5, 5, 5, 6, 4, 4, 4, 4],
        [5, 5, 5, 5, 6, 6, 6, 4, 4],
        [7, 5, 5, 5, 5, 6, 6, 4, 4],
        [7, 7, 5, 5, 5, 8, 6, 4, 4]
      ]
    },
    {
      "name": "Map n° 20",
      "caseNumber": 9,
      "colorGrid": [
        [1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 2, 2, 2, 2, 2, 0, 0],
        [1, 1, 2, 3, 2, 2, 2, 0, 0],
        [1, 1, 2, 3, 3, 2, 2, 0, 0],
        [1, 1, 1, 3, 3, 3, 3, 4, 4],
        [1, 1, 1, 1, 1, 1, 1, 4, 4],
        [1, 1, 1, 1, 1, 1, 4, 4, 4],
        [1, 1, 1, 1, 1, 1, 4, 4, 4],
        [1, 1, 1, 1, 1, 1, 4, 4, 4]
      ]
    },
    {
      "name": "Map n° 23",
      "caseNumber": 9,
      "colorGrid": [
        [8, 8, 6, 0, 0, 0, 0, 0, 0],
        [6, 6, 8, 0, 1, 1, 1, 1, 0],
        [8, 6, 6, 0, 1, 1, 1, 1, 0],
        [6, 6, 8, 0, 1, 1, 1, 1, 0],
        [6, 6, 8, 2, 2, 2, 2, 0, 0],
        [6, 6, 6, 3, 3, 2, 2, 2, 2],
        [4, 4, 6, 6, 6, 4, 4, 4, 4],
        [4, 4, 6, 6, 6, 4, 4, 4, 4],
        [4, 4, 4, 4, 4, 4, 4, 4, 4]
      ]
    },
    {
      "name": "Map n° 24",
      "caseNumber": 9,
      "colorGrid": [
        [0, 1, 1, 2, 2, 3, 3, 3, 3],
        [0, 1, 1, 2, 2, 3, 3, 3, 3],
        [0, 1, 1, 1, 1, 1, 1, 1, 1],
        [4, 4, 4, 4, 4, 4, 4, 4, 4],
        [4, 4, 4, 4, 4, 4, 4, 4, 4],
        [4, 4, 4, 4, 4, 4, 4, 4, 4],
        [5, 5, 5, 5, 5, 5, 5, 5, 5],
        [5, 5, 5, 5, 5, 5, 5, 5, 5],
        [5, 5, 5, 5, 5, 5, 5, 5, 5]
      ]
    },
    {
      "name": "Map n° 25",
      "caseNumber": 9,
      "colorGrid": [
        [8, 0, 0, 0, 0, 1, 1, 1, 1],
        [8, 0, 0, 0, 0, 1, 1, 1, 1],
        [8, 8, 8, 0, 0, 0, 1, 1, 1],
        [8, 8, 8, 0, 0, 0, 1, 1, 1],
        [8, 8, 8, 0, 0, 0, 1, 1, 1],
        [8, 8, 8, 0, 0, 0, 1, 1, 1],
        [8, 8, 8, 8, 8, 8, 1, 1, 1],
        [8, 8, 8, 8, 8, 8, 1, 1, 1],
        [8, 8, 8, 8, 8, 8, 1, 1, 1]
      ]
    },
    {
      "name": "Map n° 26",
      "caseNumber": 9,
      "colorGrid": [
        [3, 3, 1, 3, 3, 0, 0, 0, 0],
        [3, 3, 1, 3, 3, 3, 2, 0, 5],
        [3, 3, 3, 3, 3, 3, 2, 5, 5],
        [3, 3, 3, 3, 3, 5, 5, 5, 5],
        [4, 3, 3, 3, 3, 5, 5, 5, 7],
        [4, 6, 3, 3, 5, 5, 5, 5, 7],
        [6, 6, 6, 3, 3, 5, 5, 5, 7],
        [6, 6, 6, 3, 3, 8, 5, 5, 7],
        [6, 6, 6, 3, 3, 8, 8, 5, 7]
      ]
    },
    {
      "name": "Map n° 60",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 2, 3, 1, 1, 0, 0, 0],
        [2, 2, 2, 3, 1, 1, 1, 1, 1],
        [2, 2, 2, 3, 3, 3, 1, 1, 1],
        [2, 2, 2, 2, 3, 3, 3, 3, 1],
        [4, 2, 2, 3, 3, 3, 3, 3, 1],
        [4, 4, 2, 7, 3, 3, 3, 3, 5],
        [4, 4, 6, 7, 3, 3, 7, 3, 5],
        [4, 4, 7, 7, 7, 7, 7, 7, 7],
        [4, 8, 8, 8, 8, 8, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 61",
      "caseNumber": 9,
      "colorGrid": [
        [0, 3, 3, 3, 1, 2, 2, 2, 2],
        [3, 3, 3, 3, 1, 2, 2, 2, 2],
        [3, 3, 3, 3, 3, 3, 2, 2, 2],
        [3, 3, 3, 3, 3, 2, 2, 2, 2],
        [3, 3, 3, 3, 4, 4, 5, 2, 2],
        [3, 3, 3, 3, 4, 4, 5, 5, 5],
        [3, 6, 4, 4, 4, 4, 7, 5, 5],
        [3, 3, 8, 8, 4, 7, 7, 7, 7],
        [3, 3, 8, 8, 4, 7, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 62",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 3, 3, 1, 1, 1, 0, 0],
        [2, 3, 3, 3, 1, 1, 1, 1, 1],
        [2, 2, 3, 3, 3, 3, 1, 1, 1],
        [2, 3, 3, 3, 3, 3, 6, 6, 6],
        [5, 3, 3, 3, 3, 3, 6, 6, 4],
        [5, 5, 3, 3, 3, 3, 6, 4, 4],
        [5, 5, 3, 3, 6, 6, 6, 6, 4],
        [5, 5, 7, 6, 6, 6, 6, 6, 6],
        [5, 5, 7, 6, 6, 6, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 63",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 2, 2, 0, 2, 2, 1, 1],
        [2, 2, 2, 2, 2, 2, 2, 1, 1],
        [2, 2, 2, 2, 2, 2, 2, 2, 2],
        [4, 2, 2, 2, 2, 2, 2, 3, 3],
        [4, 4, 4, 6, 5, 5, 5, 5, 5],
        [6, 6, 6, 6, 5, 5, 5, 5, 5],
        [6, 6, 6, 6, 5, 5, 5, 5, 5],
        [6, 6, 6, 7, 7, 7, 7, 7, 5],
        [6, 6, 8, 7, 7, 7, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 64",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 2, 0, 0, 0, 0, 1, 1],
        [2, 2, 2, 2, 2, 0, 1, 1, 1],
        [2, 2, 2, 2, 2, 0, 0, 1, 3],
        [2, 2, 2, 2, 2, 2, 0, 1, 3],
        [2, 2, 2, 4, 4, 4, 4, 1, 3],
        [6, 6, 6, 6, 6, 4, 5, 7, 7],
        [6, 6, 6, 6, 6, 7, 7, 7, 7],
        [6, 8, 8, 6, 6, 7, 7, 7, 7],
        [8, 8, 8, 8, 7, 7, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 65",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 1, 1, 1, 1, 0, 4],
        [1, 1, 1, 1, 1, 1, 1, 0, 4],
        [1, 1, 1, 1, 1, 6, 2, 4, 4],
        [1, 1, 1, 3, 1, 6, 4, 4, 4],
        [1, 1, 5, 5, 6, 6, 6, 4, 4],
        [5, 5, 5, 5, 6, 6, 6, 4, 4],
        [6, 6, 6, 6, 6, 6, 6, 6, 6],
        [7, 7, 6, 8, 8, 8, 8, 8, 6],
        [7, 7, 7, 8, 8, 8, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 66",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 2, 2, 2, 0, 1, 1, 1],
        [2, 2, 2, 2, 2, 2, 1, 1, 1],
        [2, 2, 2, 2, 2, 2, 2, 1, 1],
        [4, 2, 2, 2, 2, 2, 3, 3, 3],
        [4, 4, 2, 2, 6, 6, 3, 3, 3],
        [7, 7, 2, 6, 6, 6, 6, 5, 5],
        [7, 7, 7, 6, 6, 6, 6, 6, 6],
        [7, 7, 7, 8, 8, 8, 6, 6, 6],
        [8, 8, 8, 8, 8, 8, 8, 6, 6]
      ]
    },
    {
      "name": "Map n° 67",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 0, 0, 2],
        [0, 0, 0, 0, 0, 0, 0, 2, 2],
        [0, 4, 4, 0, 0, 3, 3, 3, 2],
        [4, 4, 6, 6, 0, 3, 5, 3, 2],
        [8, 8, 6, 6, 6, 3, 5, 5, 2],
        [8, 8, 8, 6, 6, 6, 5, 7, 2],
        [8, 8, 8, 6, 8, 8, 5, 7, 2],
        [8, 8, 8, 8, 8, 8, 2, 2, 2]
      ]
    },
    {
      "name": "Map n° 68",
      "caseNumber": 9,
      "colorGrid": [
        [2, 0, 0, 0, 1, 1, 1, 1, 1],
        [2, 2, 2, 2, 1, 1, 1, 1, 1],
        [2, 2, 2, 2, 1, 5, 5, 1, 1],
        [2, 2, 2, 3, 5, 5, 5, 5, 5],
        [2, 2, 2, 5, 5, 5, 4, 6, 6],
        [5, 5, 5, 5, 5, 5, 5, 6, 6],
        [5, 5, 5, 5, 7, 5, 8, 8, 6],
        [5, 5, 5, 5, 7, 7, 8, 8, 8],
        [5, 5, 5, 7, 7, 7, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 69",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 2, 2, 2, 3, 3, 3, 3],
        [0, 0, 2, 2, 2, 3, 1, 3, 3],
        [4, 2, 2, 2, 3, 3, 3, 3, 3],
        [4, 4, 4, 4, 3, 3, 3, 3, 3],
        [4, 4, 4, 4, 3, 3, 3, 3, 3],
        [4, 4, 4, 6, 6, 6, 7, 3, 5],
        [4, 4, 4, 6, 6, 6, 7, 7, 5],
        [4, 6, 6, 6, 6, 6, 7, 7, 7],
        [4, 6, 6, 6, 8, 7, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 70",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 0, 0, 0, 0, 0, 0, 1],
        [0, 0, 0, 0, 0, 0, 0, 0, 1],
        [0, 2, 0, 0, 0, 3, 3, 3, 1],
        [4, 4, 4, 4, 4, 4, 3, 5, 5],
        [4, 4, 4, 4, 4, 6, 6, 5, 5],
        [4, 4, 4, 4, 6, 6, 6, 5, 5],
        [4, 7, 7, 4, 6, 6, 6, 8, 8],
        [7, 7, 7, 4, 6, 8, 8, 8, 8],
        [7, 7, 7, 8, 8, 8, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 71",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 1, 0, 0, 3, 3, 3],
        [1, 1, 1, 1, 0, 0, 3, 3, 3],
        [1, 1, 1, 4, 2, 3, 3, 3, 3],
        [1, 4, 4, 4, 4, 3, 3, 3, 3],
        [1, 4, 4, 4, 4, 3, 3, 3, 3],
        [1, 4, 4, 4, 3, 3, 5, 3, 3],
        [1, 4, 6, 8, 8, 7, 5, 3, 3],
        [1, 8, 6, 8, 8, 7, 7, 7, 3],
        [8, 8, 8, 8, 7, 7, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 72",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 2, 2, 0, 3, 3, 3],
        [1, 1, 1, 2, 2, 2, 3, 3, 3],
        [1, 2, 2, 2, 2, 2, 3, 3, 3],
        [1, 2, 2, 2, 2, 2, 3, 3, 3],
        [1, 1, 2, 4, 4, 2, 3, 3, 3],
        [1, 1, 4, 4, 4, 3, 3, 3, 5],
        [1, 1, 6, 6, 4, 3, 3, 5, 5],
        [8, 8, 6, 6, 6, 6, 7, 5, 5],
        [8, 8, 8, 8, 8, 8, 7, 5, 5]
      ]
    },
    {
      "name": "Map n° 73",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 0, 0, 1, 1, 1, 1, 1],
        [2, 2, 2, 2, 1, 1, 1, 1, 1],
        [2, 2, 2, 2, 2, 1, 1, 1, 1],
        [6, 2, 2, 2, 2, 2, 3, 1, 1],
        [6, 4, 5, 5, 5, 5, 3, 1, 1],
        [6, 6, 5, 5, 5, 5, 1, 1, 1],
        [6, 6, 5, 5, 5, 8, 8, 8, 1],
        [6, 6, 6, 8, 8, 8, 8, 8, 7],
        [6, 6, 6, 8, 8, 8, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 74",
      "caseNumber": 9,
      "colorGrid": [
        [3, 1, 1, 0, 0, 0, 0, 0, 0],
        [3, 1, 3, 3, 0, 0, 0, 0, 2],
        [3, 3, 3, 3, 0, 2, 2, 2, 2],
        [3, 3, 3, 3, 0, 0, 7, 2, 2],
        [3, 3, 4, 4, 4, 7, 7, 7, 7],
        [3, 3, 4, 7, 7, 7, 7, 7, 5],
        [3, 3, 3, 6, 7, 7, 7, 7, 7],
        [3, 3, 3, 8, 7, 7, 7, 7, 7],
        [3, 8, 8, 8, 7, 7, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 75",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 1, 1, 1, 1],
        [0, 0, 2, 2, 1, 1, 1, 1, 1],
        [0, 0, 2, 2, 1, 5, 5, 1, 1],
        [0, 0, 2, 2, 5, 5, 5, 5, 5],
        [0, 0, 4, 4, 5, 5, 5, 5, 5],
        [0, 0, 4, 4, 5, 5, 5, 5, 5],
        [6, 6, 6, 6, 6, 6, 5, 5, 5],
        [6, 6, 6, 6, 6, 6, 5, 5, 5]
      ]
    },
    {
      "name": "Map n° 76",
      "caseNumber": 9,
      "colorGrid": [
        [5, 0, 0, 5, 3, 4, 4, 2, 4],
        [5, 5, 5, 5, 3, 3, 4, 2, 4],
        [5, 5, 5, 5, 3, 3, 4, 4, 4],
        [5, 5, 5, 5, 3, 4, 4, 4, 4],
        [5, 5, 5, 4, 4, 4, 4, 4, 4],
        [5, 5, 5, 5, 5, 6, 6, 8, 8],
        [5, 5, 7, 5, 6, 6, 6, 8, 8],
        [5, 5, 7, 6, 6, 6, 8, 8, 8],
        [7, 7, 7, 9, 9, 8, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 77",
      "caseNumber": 9,
      "colorGrid": [
        [3, 3, 3, 0, 0, 0, 0, 0, 0],
        [3, 3, 3, 0, 4, 4, 4, 4, 2],
        [3, 3, 3, 4, 4, 4, 4, 4, 4],
        [5, 5, 5, 5, 4, 4, 4, 4, 4],
        [5, 5, 5, 5, 5, 6, 6, 6, 6],
        [5, 7, 7, 7, 7, 7, 6, 6, 6],
        [5, 7, 7, 7, 7, 6, 6, 6, 6],
        [5, 7, 7, 7, 6, 6, 6, 4, 4],
        [9, 9, 7, 7, 6, 6, 6, 4, 4]
      ]
    },
    {
      "name": "Map n° 78",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 0, 0, 2, 2, 2, 2, 2],
        [0, 0, 0, 0, 2, 2, 2, 2, 2],
        [0, 3, 3, 3, 2, 2, 2, 2, 2],
        [0, 3, 3, 3, 2, 2, 2, 2, 4],
        [0, 3, 3, 5, 2, 2, 2, 6, 6],
        [3, 3, 7, 7, 2, 9, 9, 6, 6],
        [8, 8, 7, 7, 7, 7, 9, 9, 6],
        [8, 8, 8, 8, 8, 8, 9, 9, 9],
        [8, 8, 8, 8, 8, 9, 9, 9, 9]
      ]
    },
    {
      "name": "Map n° 79",
      "caseNumber": 9,
      "colorGrid": [
        [2, 6, 3, 0, 0, 0, 0, 0, 0],
        [2, 6, 3, 3, 3, 0, 3, 0, 0],
        [6, 6, 6, 3, 3, 3, 3, 0, 0],
        [6, 4, 6, 6, 3, 3, 3, 3, 3],
        [6, 6, 6, 6, 6, 3, 5, 7, 9],
        [6, 6, 6, 6, 6, 6, 6, 7, 9],
        [6, 6, 6, 8, 8, 8, 7, 7, 9],
        [6, 8, 8, 8, 8, 8, 8, 9, 9],
        [6, 8, 8, 8, 8, 8, 8, 9, 9]
      ]
    },
    {
      "name": "Map n° 80",
      "caseNumber": 9,
      "colorGrid": [
        [3, 3, 3, 0, 0, 0, 0, 0, 2],
        [3, 3, 3, 0, 0, 0, 2, 2, 2],
        [3, 3, 3, 0, 0, 0, 0, 0, 5],
        [3, 3, 3, 3, 4, 9, 9, 9, 5],
        [6, 6, 6, 9, 4, 9, 9, 9, 5],
        [6, 6, 8, 9, 9, 9, 9, 9, 9],
        [6, 6, 8, 8, 9, 9, 7, 9, 9],
        [6, 8, 8, 8, 8, 9, 9, 9, 9],
        [8, 8, 8, 8, 9, 9, 9, 9, 9]
      ]
    },
    {
      "name": "Map n° 81",
      "caseNumber": 9,
      "colorGrid": [
        [5, 5, 5, 0, 0, 0, 0, 0, 0],
        [5, 2, 2, 0, 0, 0, 0, 0, 0],
        [5, 5, 5, 5, 4, 4, 4, 0, 3],
        [5, 5, 5, 5, 4, 4, 5, 6, 3],
        [5, 5, 5, 5, 5, 5, 5, 6, 6],
        [5, 5, 5, 5, 5, 5, 5, 6, 6],
        [7, 7, 5, 5, 5, 5, 8, 6, 6],
        [7, 7, 5, 5, 5, 5, 8, 8, 8],
        [7, 7, 5, 9, 9, 5, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 82",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 2, 2, 2, 0, 3, 3, 3],
        [2, 2, 2, 2, 2, 0, 3, 3, 3],
        [2, 2, 2, 2, 2, 2, 3, 3, 3],
        [4, 4, 4, 2, 2, 2, 3, 3, 3],
        [4, 4, 4, 5, 5, 5, 5, 5, 8],
        [6, 4, 4, 5, 9, 5, 5, 8, 8],
        [6, 9, 9, 7, 9, 9, 9, 8, 8],
        [9, 9, 9, 9, 9, 9, 9, 8, 8],
        [9, 9, 9, 9, 9, 9, 9, 9, 8]
      ]
    },
    {
      "name": "Map n° 83",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 1, 1, 1, 1, 1, 1, 1],
        [2, 0, 1, 1, 1, 1, 1, 1, 1],
        [2, 2, 1, 1, 1, 1, 1, 1, 1],
        [2, 1, 1, 1, 3, 1, 1, 1, 1],
        [1, 1, 1, 5, 5, 5, 4, 4, 4],
        [1, 1, 1, 5, 5, 5, 4, 4, 4],
        [8, 8, 1, 5, 7, 4, 4, 4, 6],
        [8, 8, 8, 7, 7, 7, 7, 7, 6],
        [8, 8, 8, 8, 8, 7, 7, 7, 6]
      ]
    },
    {
      "name": "Map n° 84",
      "caseNumber": 9,
      "colorGrid": [
        [4, 2, 2, 2, 0, 1, 1, 1, 1],
        [4, 4, 2, 2, 1, 1, 1, 1, 1],
        [4, 4, 2, 2, 2, 2, 1, 5, 5],
        [4, 4, 4, 4, 4, 3, 5, 5, 5],
        [4, 4, 4, 4, 4, 4, 5, 5, 5],
        [4, 4, 4, 4, 5, 5, 5, 5, 5],
        [4, 4, 4, 6, 6, 5, 5, 5, 5],
        [8, 4, 4, 6, 6, 5, 5, 7, 7],
        [8, 8, 4, 5, 5, 5, 5, 7, 7]
      ]
    },
    {
      "name": "Map n° 85",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [2, 2, 2, 0, 0, 0, 0, 0, 1],
        [2, 2, 2, 2, 2, 2, 2, 2, 1],
        [3, 3, 5, 5, 4, 4, 4, 4, 1],
        [5, 5, 5, 5, 4, 4, 4, 4, 4],
        [5, 5, 5, 5, 4, 4, 5, 4, 4],
        [5, 5, 5, 5, 5, 5, 5, 6, 6],
        [8, 8, 5, 5, 7, 5, 5, 6, 6],
        [8, 8, 5, 5, 5, 5, 5, 6, 6]
      ]
    },
    {
      "name": "Map n° 86",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 0, 0, 0, 3, 3, 1, 1],
        [0, 0, 0, 3, 3, 3, 1, 1, 1],
        [0, 0, 2, 3, 3, 3, 1, 1, 1],
        [0, 0, 3, 3, 3, 3, 3, 3, 1],
        [0, 4, 4, 3, 3, 3, 3, 3, 6],
        [0, 4, 4, 3, 5, 3, 6, 6, 6],
        [7, 6, 6, 6, 6, 6, 6, 6, 6],
        [7, 7, 7, 7, 6, 6, 6, 6, 6],
        [7, 7, 7, 6, 6, 6, 8, 8, 6]
      ]
    },
    {
      "name": "Map n° 87",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 0, 0, 0, 0],
        [3, 3, 3, 1, 1, 1, 4, 2, 0],
        [5, 5, 3, 1, 1, 4, 4, 4, 4],
        [7, 5, 5, 4, 4, 4, 4, 4, 4],
        [7, 5, 5, 4, 6, 6, 4, 4, 4],
        [7, 5, 5, 8, 6, 6, 6, 4, 4],
        [7, 7, 7, 8, 8, 8, 8, 8, 8],
        [7, 7, 7, 8, 8, 8, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 88",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 4, 1, 1, 1, 1, 1, 1],
        [0, 0, 4, 1, 1, 1, 1, 1, 1],
        [2, 2, 4, 4, 4, 1, 1, 1, 1],
        [2, 4, 4, 4, 4, 1, 3, 3, 3],
        [4, 4, 4, 4, 4, 4, 4, 5, 5],
        [6, 6, 6, 4, 4, 4, 4, 5, 5],
        [6, 6, 6, 6, 6, 4, 7, 7, 7],
        [6, 6, 6, 6, 7, 7, 7, 7, 7],
        [6, 6, 6, 6, 7, 7, 7, 8, 8]
      ]
    },
    {
      "name": "Map n° 89",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 2, 0, 2, 2, 2, 2, 2],
        [2, 2, 2, 2, 2, 2, 2, 2, 1],
        [3, 3, 2, 2, 2, 2, 2, 2, 2],
        [3, 3, 3, 2, 2, 2, 4, 2, 2],
        [3, 3, 5, 5, 2, 2, 4, 4, 4],
        [5, 5, 5, 5, 5, 4, 4, 4, 4],
        [5, 5, 5, 5, 7, 4, 6, 6, 6],
        [8, 5, 5, 7, 7, 4, 4, 6, 6],
        [8, 5, 5, 5, 7, 4, 4, 4, 6]
      ]
    },
    {
      "name": "Map n° 90",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 1, 1, 1, 2, 2, 2, 2],
        [0, 1, 1, 1, 1, 2, 2, 2, 2],
        [0, 1, 3, 2, 2, 2, 2, 2, 2],
        [3, 3, 3, 2, 2, 2, 2, 4, 2],
        [8, 8, 3, 2, 2, 2, 4, 4, 4],
        [8, 8, 6, 2, 2, 5, 5, 5, 5],
        [8, 8, 6, 8, 8, 5, 5, 5, 5],
        [8, 8, 8, 8, 8, 5, 7, 5, 5],
        [8, 8, 8, 8, 8, 8, 8, 8, 5]
      ]
    },
    {
      "name": "Map n° 91",
      "caseNumber": 9,
      "colorGrid": [
        [3, 3, 1, 1, 1, 1, 1, 0, 2],
        [3, 3, 1, 1, 1, 1, 1, 2, 2],
        [3, 3, 1, 1, 1, 1, 1, 1, 2],
        [3, 3, 3, 3, 5, 1, 4, 4, 6],
        [5, 5, 5, 5, 5, 1, 4, 4, 6],
        [5, 5, 5, 5, 6, 6, 4, 6, 6],
        [7, 7, 5, 7, 6, 6, 6, 6, 6],
        [7, 7, 7, 7, 8, 6, 6, 6, 6],
        [7, 7, 7, 7, 8, 8, 8, 8, 8]
      ]
    },
    {
      "name": "Map n° 92",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 0, 0, 0, 0, 0, 0],
        [5, 1, 1, 2, 2, 0, 0, 0, 3],
        [5, 5, 5, 5, 2, 0, 0, 3, 3],
        [5, 5, 5, 4, 0, 0, 3, 3, 3],
        [5, 5, 5, 4, 5, 3, 3, 3, 3],
        [5, 5, 5, 5, 5, 3, 3, 3, 3],
        [5, 5, 5, 5, 5, 6, 6, 6, 6],
        [5, 5, 7, 7, 7, 7, 6, 6, 6],
        [5, 7, 7, 7, 7, 7, 8, 6, 6]
      ]
    },
    {
      "name": "Map n° 93",
      "caseNumber": 9,
      "colorGrid": [
        [0, 0, 0, 0, 0, 1, 1, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 1, 1],
        [0, 0, 4, 1, 1, 1, 1, 1, 2],
        [4, 4, 4, 1, 1, 3, 2, 2, 2],
        [4, 4, 4, 1, 1, 1, 5, 2, 2],
        [4, 4, 4, 1, 1, 5, 5, 5, 2],
        [4, 6, 6, 1, 1, 7, 7, 7, 7],
        [6, 6, 8, 8, 8, 7, 7, 7, 7],
        [8, 8, 8, 8, 8, 7, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 94",
      "caseNumber": 9,
      "colorGrid": [
        [3, 0, 0, 0, 0, 0, 0, 0, 0],
        [3, 0, 0, 0, 0, 0, 0, 0, 1],
        [3, 4, 4, 4, 2, 4, 0, 0, 5],
        [3, 4, 4, 4, 4, 4, 4, 5, 5],
        [3, 6, 4, 4, 4, 4, 5, 5, 5],
        [6, 6, 6, 6, 4, 5, 5, 5, 5],
        [6, 6, 6, 6, 6, 7, 7, 7, 7],
        [6, 6, 6, 6, 6, 7, 7, 7, 7],
        [8, 8, 6, 6, 6, 7, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 95",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 3, 0, 4, 4, 0],
        [3, 3, 3, 3, 3, 4, 4, 2, 2],
        [3, 3, 3, 4, 4, 4, 4, 4, 4],
        [3, 3, 3, 3, 4, 4, 4, 4, 4],
        [5, 5, 3, 3, 4, 4, 4, 4, 4],
        [5, 5, 3, 6, 4, 4, 4, 4, 4],
        [5, 5, 3, 4, 4, 4, 4, 4, 7],
        [5, 5, 3, 3, 4, 8, 4, 4, 7]
      ]
    },
    {
      "name": "Map n° 96",
      "caseNumber": 9,
      "colorGrid": [
        [4, 4, 4, 4, 1, 1, 2, 0, 0],
        [4, 4, 4, 1, 1, 1, 2, 2, 0],
        [4, 4, 4, 4, 4, 4, 2, 2, 2],
        [4, 4, 4, 4, 3, 5, 2, 2, 2],
        [4, 4, 4, 4, 5, 5, 5, 5, 5],
        [6, 4, 4, 4, 5, 5, 5, 5, 5],
        [6, 6, 4, 4, 5, 7, 7, 5, 5],
        [6, 6, 6, 6, 7, 7, 7, 7, 5],
        [6, 6, 8, 6, 7, 7, 7, 7, 5]
      ]
    },
    {
      "name": "Map n° 97",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 6, 1, 1, 1, 1, 0, 0],
        [2, 2, 6, 1, 1, 1, 1, 1, 1],
        [2, 2, 6, 1, 1, 1, 1, 1, 1],
        [2, 6, 6, 6, 3, 3, 1, 1, 1],
        [4, 4, 6, 6, 3, 6, 5, 5, 5],
        [6, 6, 6, 6, 6, 6, 6, 5, 7],
        [6, 6, 6, 6, 6, 6, 6, 7, 7],
        [6, 6, 6, 6, 6, 6, 7, 7, 7],
        [6, 8, 8, 8, 8, 8, 7, 7, 7]
      ]
    },
    {
      "name": "Map n° 98",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 2, 0, 0, 0],
        [1, 1, 3, 5, 0, 2, 0, 4, 4],
        [1, 5, 5, 5, 5, 5, 4, 4, 4],
        [5, 5, 5, 5, 5, 5, 5, 5, 6],
        [5, 5, 5, 5, 5, 5, 5, 5, 6],
        [5, 5, 5, 7, 7, 5, 5, 5, 5],
        [8, 8, 5, 7, 7, 7, 7, 5, 5]
      ]
    },
    {
      "name": "Map n° 99",
      "caseNumber": 9,
      "colorGrid": [
        [2, 2, 2, 5, 0, 0, 1, 1, 1],
        [2, 2, 2, 5, 1, 1, 1, 1, 1],
        [4, 4, 2, 5, 5, 5, 3, 5, 1],
        [4, 4, 4, 4, 5, 5, 3, 5, 1],
        [4, 4, 4, 4, 5, 5, 5, 5, 5],
        [4, 7, 4, 5, 5, 6, 5, 5, 5],
        [4, 7, 4, 6, 6, 6, 5, 5, 5],
        [7, 7, 6, 6, 6, 6, 6, 5, 5],
        [7, 7, 7, 6, 6, 8, 6, 5, 5]
      ]
    },
    {
      "name": "Map n° 100",
      "caseNumber": 9,
      "colorGrid": [
        [1, 1, 1, 3, 0, 0, 0, 0, 0],
        [3, 1, 1, 3, 2, 2, 2, 2, 2],
        [3, 3, 3, 3, 2, 2, 2, 2, 2],
        [3, 3, 3, 3, 2, 2, 2, 2, 2],
        [3, 3, 3, 3, 4, 2, 2, 2, 5],
        [3, 3, 6, 6, 6, 5, 5, 5, 5],
        [3, 6, 6, 6, 6, 5, 5, 5, 5],
        [6, 6, 6, 6, 6, 6, 5, 5, 7],
        [6, 6, 8, 6, 5, 5, 5, 5, 7]
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    loadTemplates(); // Renk şablonlarını yükle
  }

  void loadTemplates() {
    for (var map in maps) {
      List<List<Color>> templateColors = [];
      for (var row in map['colorGrid']) {
        List<Color> colorRow = row.map<Color>((colorIndex) {
          switch (colorIndex) {
            case 0:
              return Colors.grey;
            case 1:
              return Colors.pink;
            case 2:
              return Colors.brown;
            case 3:
              return Colors.red;
            case 4:
              return Colors.green;
            case 5:
              return Colors.blue;
            case 6:
              return Colors.yellow;
            case 7:
              return Colors.orange;
            default:
              return Colors.purple;
          }
        }).toList();
        templateColors.add(colorRow);
      }
      templates.add(templateColors);
    }
    setState(() {}); // Ekranı güncelle
  }

  bool isInvalidStarPosition(int row, int col) {
    bool control = true;
    // Aynı satırda veya sütunda başka yıldız var mı kontrolü
    for (int i = 0; i < gridSize; i++) {
      if ((i != col && board[row][i] == 2) ||
          (i != row && board[i][col] == 2)) {
        control = false;
        return true;
      }
    }

    // Komşu karelerde başka yıldız var mı kontrolü
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = row + i;
        int newCol = col + j;
        if (newRow >= 0 &&
            newRow < gridSize &&
            newCol >= 0 &&
            newCol < gridSize &&
            !(i == 0 && j == 0) &&
            board[newRow][newCol] == 2) {
          control = false;
          return true;
        }
      }
    }

    // Aynı renk bloğunda başka yıldız var mı kontrolü
    int color = maps[gameTemplateIndex]["colorGrid"][row]
        [col]; // Null kontrolü ekleniyor
    if (color == null) {
      return true; // Eğer color null ise geçerli bir yıldız yerleşimi değil
    }

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        // Renk bloğunda yıldız kontrolü
        if (maps[gameTemplateIndex]["colorGrid"][r][c] == color &&
            board[r][c] == 2 &&
            (r != row || c != col)) {
          control = false;
          return true;
        }
      }
    }
    finishgamecontroller = true;
    return false;
  }

  bool finishgamecontroller = false;

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tebrikler!'),
          content: const Text('Oyunu kazandınız!'),
          actions: [
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  board = List.generate(
                      9, (_) => List.filled(9, 0)); // Oyunu sıfırla
                  gameWon = false; // Kazanma durumunu sıfırla
                });
              },
            ),
          ],
        );
      },
    );
  }

  void checkWinCondition() {
    Set<String> queensInRows = {}; // Satırlardaki taçların konumunu takip et
    Set<String> queensInColumns = {}; // Sütunlardaki taçların konumunu takip et
    Set<Color> uniqueColors = {}; // Farklı renkleri takip et
    bool hasInvalidPosition = false; // Hatalı pozisyon kontrolü

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (board[row][col] == 2) {
          // Eğer hücrede taç varsa
          String rowKey = 'row$row';
          String colKey = 'col$col';
          queensInRows.add(rowKey);
          queensInColumns.add(colKey);
          uniqueColors.add(templates[currentTemplateIndex][row][col]);

          // Hatalı pozisyon kontrolü
          if (isInvalidStarPosition(row, col)) {
            hasInvalidPosition = true;
          }
        }
      }
    }

    // Tüm satırlarda, sütunlarda ve renk bölgelerinde yalnızca bir taç varsa ve geçersiz pozisyon yoksa
    if (queensInRows.length == gridSize &&
        queensInColumns.length == gridSize &&
        uniqueColors.length == gridSize &&
        !hasInvalidPosition) {
      gameWon = true; // Oyunu kazandınız
      _showWinDialog(); // Kazanma diyalogunu göster
    }
  }

  void showGameRules() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oyun Kuralları'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    '1. Amacınız her satır, sütun ve renk bölgesinde tam olarak bir Queen olmasını sağlamaktır.'),
                Text(
                    '2. X yerleştirmek için bir kez, Queen için iki kez dokunun. Queen yerleştirilemeyecek yerleri işaretlemek için X’i kullanın.'),
                Text(
                    '3. İki Queen birbirlerine çapraz olarak bile temas edemez.'),
                Text('Her satırda yalnızca bir Queen olabilir.'),
                Text('Her sütunda yalnızca bir Queen olabilir.'),
                Text('Her renk bölgesinde yalnızca bir Queen olabilir.'),
                Text('İki Queen birbirlerine çapraz olarak bile temas edemez.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      board = List.generate(9, (_) => List.filled(9, 0)); // Oyunu sıfırla
      gameWon = false; // Kazanma durumunu sıfırla
      finishgamecontroller = false;
    });
  }

  void nextTemplate() {
    setState(() {
      currentTemplateIndex =
          (currentTemplateIndex + 1) % templates.length; // Sonraki şablona geç
      gameTemplateIndex = (gameTemplateIndex + 1) % maps.length;
      resetGame(); // Oyunu sıfırla
    });
  }

  void previousTemplate() {
    setState(() {
      currentTemplateIndex = (currentTemplateIndex - 1 + templates.length) %
          templates.length; // Önceki şablona geç
      gameTemplateIndex = (gameTemplateIndex - 1 + maps.length) % maps.length;
      resetGame(); // Oyunu sıfırla
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queens Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Farklı Renk Şablonları',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  int row = index ~/ gridSize;
                  int col = index % gridSize;
                  bool isInvalid =
                      board[row][col] == 2 && isInvalidStarPosition(row, col);

                  return GestureDetector(
                    onTap: gameWon
                        ? null
                        : () {
                            setState(() {
                              if (board[row][col] == 0) {
                                board[row][col] = 1; // X koy
                              } else if (board[row][col] == 1) {
                                board[row][col] = 2; // Yıldız koy
                              } else {
                                board[row][col] = 0; // Boşalt
                              }
                              checkWinCondition();
                            });
                          },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: templates[currentTemplateIndex][row][col],
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: board[row][col] == 1
                                ? const Text(
                                    'X',
                                    style: TextStyle(fontSize: 24),
                                  )
                                : board[row][col] == 2
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.black,
                                        size: 30.0,
                                      )
                                    : Container(), // For empty cells
                          ),
                        ),
                        if (isInvalid)
                          Positioned(
                            left: 4,
                            top: 4,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.clear,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Template indexini göster
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Bölüm: ${currentTemplateIndex + 1}/${templates.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            // Oyun kurallarını gösteren buton
            ElevatedButton(
              onPressed: showGameRules,
              child: const Text('Oyun Kurallarını Göster'),
            ),
            // Geçiş butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: previousTemplate,
                  child: const Text('Önceki Bölüm'),
                ),
                ElevatedButton(
                  onPressed: nextTemplate,
                  child: const Text('Sonraki Bölüm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}