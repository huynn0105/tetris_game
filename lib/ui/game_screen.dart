part of 'tetris_screen.dart';

enum Collision {
  LANDED,
  LANDED_BLOCK,
  HIT_WALL,
  HIT_BLOCK,
  NONE,
}

const double BLOCKS_X = 10;
const double BLOCKS_Y = 20;
const int REFRESH_RATE = 800;

class _Game extends StatefulWidget {
  const _Game({
    Key? key,
  }) : super(key: key);

  @override
  State<_Game> createState() => _GameState();
}

class _GameState extends State<_Game> {
  final GlobalKey _keyGameArea = GlobalKey();
  late DataProvider dataProvider;
  @override
  void initState() {
    dataProvider = context.read<DataProvider>();
    Future.delayed(Duration.zero, () {
      RenderBox renderBoxGame =
          _keyGameArea.currentContext?.findRenderObject() as RenderBox;

      dataProvider.initData((renderBoxGame.size.width) / BLOCKS_X);
    });
    super.initState();
  }

  Positioned getGameOverRect() {
    return Positioned(
      left: dataProvider.subBlockWidth * 1,
      top: dataProvider.subBlockWidth * 6,
      child: Container(
        width: dataProvider.subBlockWidth * 8,
        height: dataProvider.subBlockWidth * 3,
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

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: BLOCKS_X / BLOCKS_Y,
      child: Container(
        key: _keyGameArea,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Consumer<DataProvider>(builder: (context, __, ___) {
          return Stack(
            children: [
              grid(),
              context.read<DataProvider>().drawBlocks(),
            ],
          );
        }),
      ),
    );
  }

  Widget grid() {
    List<Widget> rows = List.generate(
      BLOCKS_X.toInt(),
      (index) => Container(
        width: dataProvider.subBlockWidth,
        height: dataProvider.subBlockWidth,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: Colors.grey.shade900,
          ),
        ),
      ),
    ).toList();
    List<Widget> columns = List.generate(
      BLOCKS_Y.toInt(),
      (index) => Row(
        children: rows,
      ),
    );
    return Column(children: columns);
  }
}
