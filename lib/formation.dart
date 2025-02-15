import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hair_app/player.dart';

class Formation extends StatefulWidget {
  const Formation({super.key});

  @override
  _FormationState createState() => _FormationState();
}

class _FormationState extends State<Formation> {
  List<Player> players = [];
  final TextEditingController individualGoodController = TextEditingController();
  final TextEditingController individualBadController = TextEditingController();
  final TextEditingController teamGoodController = TextEditingController();
  final TextEditingController teamBadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFormation();
  }

  void _initializeFormation() {
    double width = 400; // フィールド横幅
    double height = 400; // フィールド縦幅
    double xCenter = width / 2;

    List<Offset> positions = [
      Offset(xCenter, height * 0.85), // GK
      Offset(xCenter - 100, height * 0.65), // DF
      Offset(xCenter + 100, height * 0.65),
      Offset(xCenter - 50, height * 0.7),
      Offset(xCenter + 50, height * 0.7), 
      Offset(xCenter - 100, height * 0.45), // MF
      Offset(xCenter + 100, height * 0.45),
      Offset(xCenter - 50, height * 0.5),
      Offset(xCenter + 50, height * 0.5), 
      Offset(xCenter - 50, height * 0.3), // FW
      Offset(xCenter + 50, height * 0.3), 
    ];

    players = List.generate(
      positions.length,
      (index) => Player(name: '${index + 1}', position: positions[index]),
    );
  }

  void _updatePosition(int index, Offset newPosition) {
    setState(() {
      players[index].position = newPosition;
    });
  }

  void _editPlayer(int index) {
    TextEditingController controller = TextEditingController(text: players[index].name);
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
        title: const Text('フォーメーション'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Image.asset('assets/images/coat2.jpg', width: 600, height: 400),
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
                }).toList(),
                Positioned.fill(
                  child: DragTarget<int>(
                    builder: (context, candidateData, rejectedData) {
                      return Container();
                    },
                    onAcceptWithDetails: (details) {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      Offset localOffset = renderBox.globalToLocal(details.offset);
                      _updatePosition(details.data, localOffset);
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildCommentSection(),
        ],
      ),
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
      child: Text(player.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
