import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/core/models/block.dart';
import 'package:tetris_game/core/models/sub_block.dart';
import 'package:tetris_game/ui/tetris_screen.dart';

class DataProvider with ChangeNotifier {
  int _score = 0;
  bool _isPlaying = false;
  Block? _nextBlock;
  Block? _currentBlock;
  late Timer timer;

  double _subBlockWidth = 0;
  bool _isGameOver = false;
  BlockMovement? _action;
  Block? get nextBlock => _nextBlock;
  List<SubBlock> _oldSubBlocks = [];
  Block? get currentBlock => _currentBlock;
  double get subBlockWidth => _subBlockWidth;

  void setNextBlock(Block? nextBlock) {
    _nextBlock = nextBlock;
    notifyListeners();
  }

  set action(BlockMovement active) {
    _action = active;
    notifyListeners();
  }

  void initData(double subBlockWidth) {
    _subBlockWidth = subBlockWidth;
    notifyListeners();
  }

  Widget getNextBlockWidget() {
    Color color = Colors.transparent;
    if (!isPlaying || _nextBlock == null) return const SizedBox();
    List<Widget> columns = [];
    for (var y = 0; y < _nextBlock!.height; ++y) {
      List<Widget> rows = [];
      for (var x = 0; x < _nextBlock!.width; ++x) {
        if (_nextBlock!.subBlocks
            .where((subBlock) => subBlock.x == x && subBlock.y == y)
            .isNotEmpty) {
          color = _nextBlock!.color;
        } else {
          color = Colors.transparent;
        }
        rows.add(
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.all(0.2),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }
      columns.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: columns,
    );
  }

  set score(int score) {
    _score = score;
    notifyListeners();
  }

  int get score => _score;

  void addScore(int score) {
    _score += score;
    notifyListeners();
  }

  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  bool get isPlaying => _isPlaying;

  Block? move(BlockMovement blockMovement) {
    if (_currentBlock != null) {
      switch (blockMovement) {
        case BlockMovement.UP:
          int y = _currentBlock!.y - 1;
          return _currentBlock!.copyWith(y: y);
        case BlockMovement.DOWN:
          int y = _currentBlock!.y + 1;
          return _currentBlock!.copyWith(y: y);
        case BlockMovement.LEFT:
          int x = _currentBlock!.x - 1;
          return _currentBlock!.copyWith(x: x);
        case BlockMovement.RIGHT:
          int x = _currentBlock!.x + 1;
          return _currentBlock!.copyWith(x: x);
        case BlockMovement.ROTATE_CLOCKWISE:
          int orientationIndex = (++_currentBlock!.orientationIndex) % 4;
          return _currentBlock!.copyWith(orientationIndex: orientationIndex);

        case BlockMovement.ROTATE_COUNTER_CLOCKWISE:
          int orientationIndex = (_currentBlock!.orientationIndex + 3) % 4;
          return _currentBlock!.copyWith(orientationIndex: orientationIndex);
      }
    }
    return null;
  }

  Block? getNewBlock() {
    int blockType = Random().nextInt(7);
    int orientationIndex = Random().nextInt(4);

    switch (blockType) {
      case 0:
        return IBlock(orientationIndex: orientationIndex);
      case 1:
        return JBlock(orientationIndex: orientationIndex);
      case 2:
        return LBlock(orientationIndex: orientationIndex);
      case 3:
        return OBlock(orientationIndex: orientationIndex);
      case 4:
        return TBlock(orientationIndex: orientationIndex);
      case 5:
        return SBlock(orientationIndex: orientationIndex);
      case 6:
        return ZBlock(orientationIndex: orientationIndex);
      default:
        return null;
    }
  }

  void startGame() {
    isPlaying = true;
    score = 0;
    _oldSubBlocks = [];
    _isGameOver = false;
    _nextBlock = getNewBlock();
    _currentBlock = getNewBlock();
    timer = Timer.periodic(const Duration(milliseconds: 500), onPlay);
  }

  void onPlay(Timer timer) {
    var status = Collision.NONE;

    if (_action != null) {
      if (!checkOnEdge(_action!) && !checkAtBottom() && !checkAboveBlock()) {
        _currentBlock = move(_action!);
      }
    }
    for (var oldSubBlock in _oldSubBlocks) {
      for (var subBlock in _currentBlock!.subBlocks) {
        var x = _currentBlock!.x + subBlock.x;
        var y = _currentBlock!.y + subBlock.y;
        if (x == oldSubBlock.x && y == oldSubBlock.y) {
          switch (_action) {
            case BlockMovement.LEFT:
              _currentBlock = move(BlockMovement.RIGHT);
              break;
            case BlockMovement.RIGHT:
              _currentBlock = move(BlockMovement.LEFT);
              break;
            case BlockMovement.ROTATE_CLOCKWISE:
              _currentBlock = move(BlockMovement.ROTATE_COUNTER_CLOCKWISE);
              break;
            default:
              break;
          }
        }
      }
    }
    if (!checkAtBottom()) {
      if (!checkAboveBlock()) {
        _currentBlock = move(BlockMovement.DOWN);
      } else {
        status = Collision.LANDED_BLOCK;
      }
    } else {
      status = Collision.LANDED;
    }
    if (status == Collision.LANDED_BLOCK && _currentBlock!.y < 0) {
      _isGameOver = true;
      endGame();
    } else if (status == Collision.LANDED || status == Collision.LANDED_BLOCK) {
      for (var subBlock in _currentBlock!.subBlocks) {
        subBlock.x += _currentBlock!.x;
        subBlock.y += _currentBlock!.y;
        _oldSubBlocks.add(subBlock);
      }
      _currentBlock = _nextBlock;
      _nextBlock = getNewBlock();
    }
    _action = null;
    updateScore();
    notifyListeners();
  }

  void updateScore() {
    var combo = 1;
    Map<int, int> rows = {};
    List<int> rowsToBeRemoved = [];
    for (var subBlock in _oldSubBlocks) {
      rows.update(subBlock.y, (value) => ++value, ifAbsent: () => 1);
    }
    rows.forEach((rowNum, count) {
      if (count == BLOCKS_X) {
        _score += combo++;
        rowsToBeRemoved.add(rowNum);
      }
    });
    if (rowsToBeRemoved.isNotEmpty) {
      removeRows(rowsToBeRemoved);
    }
  }

  void removeRows(List<int> rowsToBeRemoved) {
    rowsToBeRemoved.sort();
    for (var rowNum in rowsToBeRemoved) {
      _oldSubBlocks.removeWhere((subBlock) => subBlock.y == rowNum);
      for (var subBlock in _oldSubBlocks) {
        if (subBlock.y < rowNum) {
          ++subBlock.y;
        }
      }
    }
  }

  void endGame() {
    _isPlaying = false;
    timer.cancel();
  }

  bool checkOnEdge(BlockMovement action) {
    bool isRotate = false;
    if (action == BlockMovement.ROTATE_COUNTER_CLOCKWISE) {
      final newBlockRotate = move(action);
      int newX = newBlockRotate!.x + newBlockRotate.width - BLOCKS_X.toInt();
      if (newX > 0) {
        _currentBlock!.x -= newX;
      }
      int newY = newBlockRotate.y + newBlockRotate.height - BLOCKS_Y.toInt();
      if (newY > 0) {
        _currentBlock!.y -= newY;
      }
      isRotate = (newBlockRotate.x < 0);
    }
    return (action == BlockMovement.LEFT && _currentBlock!.x <= 0) ||
        (action == BlockMovement.RIGHT &&
            _currentBlock!.x + _currentBlock!.width >= BLOCKS_X) ||
        isRotate;
  }

  bool checkAtBottom() {
    if (_action == BlockMovement.DOWN) {
      final nextBlock = move(_action!);
      int newY = (nextBlock!.y + nextBlock.height) - BLOCKS_Y.toInt();
      if (newY == 0) {
        _currentBlock!.y += 1;
        return true;
      } else if (newY > 0) {
        return true;
      }
    }
    return _currentBlock!.y + _currentBlock!.height >= BLOCKS_Y;
  }

  bool checkAboveBlock() {
    for (var oldSubBlock in _oldSubBlocks) {
      for (var subBlock in _currentBlock!.subBlocks) {
        var x = _currentBlock!.x + subBlock.x;
        var y = _currentBlock!.y + subBlock.y;
        if (x == oldSubBlock.x && y + 1 == oldSubBlock.y) {
          return true;
        }
      }
    }
    return false;
  }

  Widget drawBlocks() {
    if (_currentBlock == null) return const SizedBox.shrink();
    List<Positioned> subBlocks = _currentBlock!.subBlocks
        .map((e) => getPositionedSquareContainer(
            e.x + _currentBlock!.x, e.y + _currentBlock!.y, e.color))
        .toList();

    //old sub-blocks
    for (var oldSubBlock in _oldSubBlocks) {
      subBlocks.add(getPositionedSquareContainer(
          oldSubBlock.x, oldSubBlock.y, oldSubBlock.color));
    }
    if (_isGameOver) {
      subBlocks.add(getGameOverRect());
    }

    return Stack(
      children: subBlocks,
    );
  }

  Positioned getGameOverRect() {
    return Positioned(
      left: _subBlockWidth * 1,
      top: _subBlockWidth * 6,
      child: Container(
        width: _subBlockWidth * 8,
        height: _subBlockWidth * 3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.red),
        child: const Text(
          'Game Over',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Positioned getPositionedSquareContainer(int x, int y, Color color) {
    return Positioned(
      left: x * _subBlockWidth,
      top: y * _subBlockWidth,
      child: Container(
        width: _subBlockWidth,
        height: _subBlockWidth,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
