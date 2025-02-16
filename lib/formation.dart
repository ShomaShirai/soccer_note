import 'package:flutter/material.dart';
import 'package:hair_app/player.dart';
import 'package:go_router/go_router.dart';

class Formation extends StatefulWidget {
  const Formation({super.key});

  @override
  _FormationState createState() => _FormationState();
}

class _FormationState extends State<Formation> {
  List<Player> players = [];
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController individualGoodController =
      TextEditingController();
  final TextEditingController individualBadController = TextEditingController();
  final TextEditingController teamGoodController = TextEditingController();
  final TextEditingController teamBadController = TextEditingController();

  int myScore = 0; // 得点の状態を管理
  int opponentScore = 0; // 得点の状態を管理

  @override
  void initState() {
    super.initState();
    _initializeFormation();
  }

  void goCalender(BuildContext context) {
    context.go('/calendar');
  }

  void _initializeFormation() {
    double xCenter = 180;

    List<Offset> positions = [
      Offset(xCenter, 230), // GK
      Offset(xCenter - 120, 170), // DF
      Offset(xCenter + 120, 170),
      Offset(xCenter - 50, 190),
      Offset(xCenter + 50, 190),
      Offset(xCenter - 120, 110), // MF
      Offset(xCenter + 120, 110),
      Offset(xCenter - 50, 130),
      Offset(xCenter + 50, 130),
      Offset(xCenter - 50, 50), // FW
      Offset(xCenter + 50, 50),
    ];

    players = List.generate(
      positions.length,
      (index) => Player(name: '${index + 1}', position: positions[index]),
    );
  }

  void _updatePosition(int index, Offset newPosition) {
    final RenderBox fieldBox =
        _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final fieldSize = fieldBox.size;
    final fieldOffset = fieldBox.localToGlobal(Offset.zero);

    double clampedX = newPosition.dx.clamp(
      fieldOffset.dx,
      fieldOffset.dx + fieldSize.width - 40,
    );
    double clampedY = newPosition.dy.clamp(
      fieldOffset.dy,
      fieldOffset.dy + fieldSize.height - 40,
    );

    setState(() {
      players[index].position = Offset(
        clampedX - fieldOffset.dx,
        clampedY - fieldOffset.dy,
      );
    });
  }

  void _increaseMyScore() {
    setState(() {
      myScore++;
    });
  }

  void _decreaseMyScore() {
    setState(() {
      if (myScore > 0) myScore--; // スコアが0以下にならないようにする
    });
  }

  void _increaseOpponentScore() {
    setState(() {
      opponentScore++;
    });
  }

  void _decreaseOpponentScore() {
    setState(() {
      if (opponentScore > 0) opponentScore--; // スコアが0以下にならないようにする
    });
  }

  // 選手を長押しした時に出す編集用ダイアログ
  void _editPlayer(int index) {
    TextEditingController controller = TextEditingController(
      text: players[index].name,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('選手を編集'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: '名前'),
              ),
              const SizedBox(height: 1),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    players[index].name = controller.text;
                    players[index].color = Colors.black;
                  });
                  Navigator.pop(context);
                },
                child: const Text('自分に選択'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  players[index].name = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => goCalender(context),
        ),
        title: const Text(
          'フォーメーション',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                key: _fieldKey,
                children: [
                  Image.asset(
                    'assets/images/coat2.jpg',
                    width: 400,
                    height: 400,
                  ),
                  ...players.asMap().entries.map((entry) {
                    int index = entry.key;
                    Player player = entry.value;
                    return Positioned(
                      left: player.position.dx,
                      top: player.position.dy,
                      child: GestureDetector(
                        onLongPress: () => _editPlayer(index),
                        child: Draggable<int>(
                          data: index,
                          feedback: _buildPlayer(player, isDragging: true),
                          childWhenDragging: const SizedBox.shrink(),
                          child: _buildPlayer(player),
                        ),
                      ),
                    );
                  }),
                  Positioned.fill(
                    child: DragTarget<int>(
                      builder:
                          (context, candidateData, rejectedData) => Container(),
                      onAcceptWithDetails: (details) {
                        _updatePosition(details.data, details.offset);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildScoreBoard(), // スコア表示エリアを追加
          _buildCommentSection(),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildScoreColumn("自チーム", myScore, _increaseMyScore, _decreaseMyScore),
          const SizedBox(width: 40), // 間隔を空ける
          _buildScoreColumn("相手チーム", opponentScore, _increaseOpponentScore, _decreaseOpponentScore),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String teamName, int score, VoidCallback onIncrease, VoidCallback onDecrease) {
    return Column(
      children: [
        Text(
          teamName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onIncrease,
              icon: const Icon(Icons.arrow_drop_up, size: 40, color: Colors.green),
            ),
            Text(
              '$score',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onDecrease,
              icon: const Icon(Icons.arrow_drop_down, size: 40, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTextField(individualGoodController, '個人の良い点'),
          _buildTextField(individualBadController, '個人の反省点'),
          _buildTextField(teamGoodController, 'チームの良い点'),
          _buildTextField(teamBadController, 'チームの反省点'),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPlayer(Player player, {bool isDragging = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: player.color.withOpacity(isDragging ? 0.5 : 1.0),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        player.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
