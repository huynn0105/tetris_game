import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_game/ui/tetris_screen.dart';

import 'core/provider/data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        title: 'Tetris Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TetrisScreen(),
      ),
    );
  }
}
