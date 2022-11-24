// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'package:tetris_game/core/models/sub_block.dart';

enum BlockMovement {
  UP,
  DOWN,
  LEFT,
  RIGHT,
  ROTATE_CLOCKWISE,
  ROTATE_COUNTER_CLOCKWISE
}

class Block {
  List<List<SubBlock>> orientations = <List<SubBlock>>[];
  int x = 0;
  int y = 0;
  int orientationIndex;

  Block({
    required Color color,
    required this.orientationIndex,
    required this.orientations,
    int? x,
    int? y,
  }) {
    this.x = x ?? 3;
    this.y = y ?? -height;
    this.color = color;
  }

  set color(Color color) {
    for (var orientation in orientations) {
      for (var subBlock in orientation) {
        subBlock.color = color;
      }
    }
  }

  Color get color {
    return orientations[0][0].color;
  }

  List<SubBlock> get subBlocks {
    return orientations[orientationIndex];
  }

  int get width {
    int maxX = 0;
    for (var subBlock in subBlocks) {
      if (subBlock.x > maxX) {
        maxX = subBlock.x;
      }
    }
    return maxX + 1;
  }

  int get height {
    int maxY = 0;
    for (var subBlock in subBlocks) {
      if (subBlock.y > maxY) {
        maxY = subBlock.y;
      }
    }
    return maxY + 1;
  }

  // void move(BlockMovement blockMovement) {
  //   switch (blockMovement) {
  //     case BlockMovement.UP:
  //       y -= 1;
  //       break;
  //     case BlockMovement.DOWN:
  //       y += 1;
  //       break;
  //     case BlockMovement.LEFT:
  //       x -= 1;
  //       break;
  //     case BlockMovement.RIGHT:
  //       x += 1;
  //       break;
  //     case BlockMovement.ROTATE_CLOCKWISE:
  //       orientationIndex = ++orientationIndex % 4;
  //       break;
  //     case BlockMovement.ROTATE_COUNTER_CLOCKWISE:
  //       orientationIndex = (orientationIndex + 3) % 4;
  //       break;
  //   }
  // }

  Block copyWith({
    List<List<SubBlock>>? orientations,
    int? x,
    int? y,
    int? orientationIndex,
    Color? color,
  }) {
    return Block(
      orientations: orientations ?? this.orientations,
      orientationIndex: orientationIndex ?? this.orientationIndex, color: color ?? this.color,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}

class IBlock extends Block {
  IBlock({required int orientationIndex})
      : super(orientations: [
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(0, 3)],
          [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(3, 0)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(0, 3)],
          [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(3, 0)],
        ], color: Colors.red.shade400, orientationIndex: orientationIndex);
}

class JBlock extends Block {
  JBlock({required int orientationIndex})
      : super(orientations: [
          [SubBlock(0, 2), SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 0)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 2)],
        ], color: Colors.yellow.shade400, orientationIndex: orientationIndex);
}

class LBlock extends Block {
  LBlock({required int orientationIndex})
      : super(orientations: [
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 2)],
          [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(0, 2)],
          [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2)],
          [SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 0), SubBlock(2, 1)],
        ], color: Colors.green.shade400, orientationIndex: orientationIndex);
}

class OBlock extends Block {
  OBlock({required int orientationIndex})
      : super(orientations: [
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 0), SubBlock(1, 1)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 0), SubBlock(1, 1)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 0), SubBlock(1, 1)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 0), SubBlock(1, 1)],
        ], color: Colors.blue.shade400, orientationIndex: orientationIndex);
}

class TBlock extends Block {
  TBlock({required int orientationIndex})
      : super(
            orientations: [
              [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(1, 1)],
              [SubBlock(0, 1), SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2)],
              [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
              [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 1)],
            ],
            color: Colors.blueAccent.shade400,
            orientationIndex: orientationIndex);
}

class SBlock extends Block {
  SBlock({required int orientationIndex})
      : super(orientations: [
          [SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
          [SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1)],
          [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
        ], color: Colors.orange.shade400, orientationIndex: orientationIndex);
}

class ZBlock extends Block {
  ZBlock({required int orientationIndex})
      : super(orientations: [
          [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(2, 1)],
          [SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 0), SubBlock(1, 1)],
          [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(2, 1)],
          [SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 0), SubBlock(1, 1)],
        ], color: Colors.cyanAccent, orientationIndex: orientationIndex);
}
