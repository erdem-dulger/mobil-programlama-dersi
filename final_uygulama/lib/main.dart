import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'database_helper.dart';
import 'dart:async';

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
      if ((i != col && board[row][i] == 51) ||
          (i != row && board[i][col] == 51)) {
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

  Timer? gameTimer;
  int elapsedSeconds = 0;
  bool gameStarted = false;

  void startGame() {
    if (_userName == null || _userName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen önce giriş yapın.')),
      );
      return;
    }
    if (!gameStarted) {
      gameStarted = true;
      startTime = DateTime.now();
      elapsedSeconds = 0;
      gameTimer?.cancel();
      gameTimer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          elapsedSeconds = DateTime.now().difference(startTime!).inSeconds;
        });
      });
    }
  }

  void resetGame() {
    setState(() {
      gameStarted = false;
      elapsedSeconds = 0;
      gameTimer?.cancel();
      board = List.generate(9, (_) => List.filled(9, 0));
      gameWon = false;
      finishgamecontroller = false;

      startGame();
    });
  }

  void switchMap() {
    setState(() {
      currentTemplateIndex = (currentTemplateIndex + 1) % templates.length;
      gameTemplateIndex = (gameTemplateIndex + 1) % maps.length;
      resetGame();
    });
  }

  int calculateScore() {
    if (elapsedSeconds <= 2 * 60) {
      return 100;
    } else if (elapsedSeconds <= 5 * 60) {
      return 75;
    } else {
      return 50;
    }
  }

  void handleWin() {
    setState(() {
      gameStarted = false;
      gameTimer?.cancel();
      gameWon = true;
    });

    int score = calculateScore();
    _saveScore(score, currentTemplateIndex);

    _showWinDialog(score, elapsedSeconds);
  }

  void _showWinDialog(int score, int timeSeconds) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tebrikler!'),
          content: Text(
              'Oyunu kazandınız!\nSkor: $score\nSüre: ${timeSeconds ~/ 60} dk ${timeSeconds % 60} sn'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  DateTime? startTime;

  // Bölüm başladığında çağır
  void startGameTimer() {
    startTime = DateTime.now();
  }

  // Bölüm bittiğinde çağır
  int calculateFinalScore() {
    if (startTime == null) return 0;
    int elapsedSeconds = DateTime.now().difference(startTime!).inSeconds;

    if (elapsedSeconds <= 2 * 60) {
      return 100;
    } else if (elapsedSeconds <= 5 * 60) {
      return 75;
    } else {
      return 50;
    }
  }

  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  //GoogleSignInAccount? _user;

  String? _userName;

//Kullanıcı adı alınır
  Future<void> _promptForUsername() async {
    String tempName = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kullanıcı Adınızı Girin'),
          content: TextField(
            onChanged: (value) {
              tempName = value;
            },
            decoration: const InputDecoration(hintText: "Kullanıcı adı"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (tempName.trim().isNotEmpty) {
                  setState(() {
                    _userName = tempName.trim();
                  });
                  startGame();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetUsername() async {
    setState(() {
      // _user = null;  // Eğer kullanıcı bilgisi burada tutuluyorsa sıfırla
      _userName = null; // Eklediysen kendi username değişkenini de sıfırla
    });
  }

  // Future<void> _saveScore(int score, int templateId) async {
  //   String userId;
  //   String userName;

  //   if (_user != null) {
  //     userId = _user!.id;
  //     userName = _user!.displayName ?? 'Unknown';
  //   } else {
  //     userId = 'anonymous';
  //     userName = 'Anonymous';

  //     // Anonim kullanıcıyı sadece bir kez kaydetmek istersen, önce var mı diye kontrol eklersin.
  //     await _dbHelper.insertUser(userId, userName);
  //   }

  //   await _dbHelper.insertScore(userId, score, templateId);
  // }

  Future<void> _showAllScores() async {
    List<Map<String, dynamic>> scores = await _dbHelper.getAllScores();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tüm Skorlar'),
          content: SingleChildScrollView(
            child: Column(
              children: scores.map((s) {
                return ListTile(
                  title: Text('Kullanıcı: ${s['userName']}'),
                  subtitle: Text(
                    'Template: ${s['templateId'] + 1}, Puan: ${s['score']}, Zaman: ${DateTime.fromMillisecondsSinceEpoch(s['timestamp'])}',
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveScore(int score, int templateId) async {
    String userName = _userName ?? 'Anonim';
    await _dbHelper.insertScore(userName, score, templateId);
  }

  Future<void> _showMyScores() async {
    List<Map<String, dynamic>> scores =
        await _dbHelper.getUserScores(_userName ?? 'Anonim');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Puanlarım'),
          content: SingleChildScrollView(
            child: Column(
              children: scores.map((s) {
                return ListTile(
                  // title: Text('Template ${s['templateId']}'),
                  title: Text('Template ${s['templateId'] + 1}'),
                  subtitle: Text('Puan: ${s['score']}'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTopScores() async {
    List<Map<String, dynamic>> topScores = await _dbHelper.getTopScores();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Top Scores'),
          content: SingleChildScrollView(
            child: Column(
              children: topScores.map((s) {
                return ListTile(
                  title: Text('${s['userName']}'),
                  subtitle: Text('Toplam Puan: ${s['totalScore']}'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     if (account != null) {
  //       setState(() {
  //         _user = account;
  //       });
  //       await _dbHelper.insertUser(
  //           account.id, account.displayName ?? 'Unknown');
  //     }
  //   } catch (e) {
  //     print('Google ile giriş yapılırken hata oluştu: $e');
  //   }
  // }

  // Future<void> _signOut() async {
  //   await _googleSignIn.signOut();
  //   setState(() {
  //     _user = null;
  //   });
  // }

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

      int score = calculateScore();
      _saveScore(score, currentTemplateIndex);
      _showWinDialog(score, elapsedSeconds);
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
                    '1. Amacınız her satır, her sütun ve her renk bölgesinde yalnızca bir adet Queen (yıldız ikonu) olmasını sağlamaktır.'),
                Text(
                    '2. X yerleştirmek için bir kez, Queen (yıldız ikonu) yerleştirmek için iki kez dokunun. Queen (yıldız ikonu) yerleştirilemeyecek yerleri işaretlemek için X’i kullanın.'),
                Text(
                    '3. İki Queen (yıldız ikonu) birbirlerine çapraz olarak bile temas edemez.'),
                Text('Her satırda yalnızca bir Queen (yıldız ikonu) olabilir.'),
                Text('Her sütunda yalnızca bir Queen (yıldız ikonu) olabilir.'),
                Text(
                    'Her renk bölgesinde yalnızca bir Queen (yıldız ikonu) olabilir.'),
                Text(
                    '4. Oyuna başlamak için önce giriş yapmanız gerekmektedir. Giriş yaptıktan sonra oyun otomatik olarak başlayacaktır.'),
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
        actions: [
          TextButton(
            onPressed: _userName != null
                ? () async {
                    await _showMyScores();
                  }
                : null,
            child: const Text('Skorlarım'),
          ),
          TextButton(
            onPressed: _showAllScores,
            child: const Text('Global Skorlar'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'Farklı Renk Şablonları',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),

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
                    onTap: (gameStarted && !gameWon)
                        ? () {
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
                          }
                        : null,
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
            // Bölüm ve Oyun Kuralları yan yana
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, left: 8.0, right: 8.0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Bölüm: ${currentTemplateIndex + 1}/${templates.length}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: showGameRules,
                    child: const Text('Oyun Kuralları'),
                  ),
                ],
              ),
            ),

            // Alt satırda: Önceki ve Sonraki Bölüm butonları
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: previousTemplate,
                      child: const Text('Önceki Bölüm',
                          textAlign: TextAlign.center),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: nextTemplate,
                      child: const Text('Sonraki Bölüm',
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),

            // Giriş Yap butonu (yeni eklenen)
            Padding(
              padding: const EdgeInsets.only(top: 0), // 16 yerine 0
              // padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Giriş Yap'),
                    onPressed: _promptForUsername,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 16), // İki buton arasına boşluk
                  ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text('Çıkış Yap'),
                    onPressed: _resetUsername,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _userName != null ? '$_userName' : 'Anonim',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
