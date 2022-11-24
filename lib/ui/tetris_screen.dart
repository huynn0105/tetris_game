import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_game/core/models/block.dart';
import 'package:tetris_game/core/models/sub_block.dart';
import 'package:tetris_game/core/provider/data_provider.dart';
part 'game_screen.dart';

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key});

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TETRIS'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                      child: _Game(),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                const Text(
                                  'Next',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    color: Colors.indigo[600],
                                    child: Consumer<DataProvider>(
                                        builder: (context, dataProvider, __) {
                                      return Center(
                                        child:
                                            dataProvider.getNextBlockWidget(),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                const Text(
                                  'Score',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    color: Colors.indigo[600],
                                    child: Consumer<DataProvider>(
                                        builder: (context, dataProvider, __) {
                                      return Center(
                                        child: Text(
                                          '${dataProvider.score}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                context.read<DataProvider>().isPlaying
                                    ? context.read<DataProvider>().endGame()
                                    : context.read<DataProvider>().startGame();
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.indigo[700],
                              elevation: 0,
                              minimumSize: const Size(double.infinity, 35),
                            ),
                            child: Text(
                              context.read<DataProvider>().isPlaying
                                  ? 'End'
                                  : 'Start',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CustomButton(
                  onTap: () {
                    context.read<DataProvider>().action = BlockMovement.LEFT;
                  },
                  child: const Icon(
                    Icons.arrow_left_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                _CustomButton(
                  onTap: () {
                    context.read<DataProvider>().action = BlockMovement.DOWN;
                  },
                  child: const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                _CustomButton(
                  onTap: () {
                    context.read<DataProvider>().action = BlockMovement.RIGHT;
                  },
                  child: const Icon(
                    Icons.arrow_right_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                _CustomButton(
                  onTap: () {
                    context.read<DataProvider>().action =
                        BlockMovement.ROTATE_COUNTER_CLOCKWISE;
                  },
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
