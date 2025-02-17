import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/formation_state.dart';

class Formation extends ConsumerStatefulWidget {
  final String matchDate; // 試合日時
  final String opponent; // 対戦相手
  const Formation({super.key, required this.matchDate, required this.opponent});

  @override
  _FormationState createState() => _FormationState();
}

class _FormationState extends ConsumerState<Formation> {
  final GlobalKey _fieldKey = GlobalKey();

  final TextEditingController myGoodController = TextEditingController();
  final TextEditingController myBadController = TextEditingController();
  final TextEditingController teamGoodController = TextEditingController();
  final TextEditingController teamBadController = TextEditingController();

  bool _hasChanges = false; // 変更フラグ

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(formationProvider.notifier)
          .initializeFormation(widget.matchDate, widget.opponent);
      _initializeFormation(); // 選手の初期座標を設定
      _loadFormationData();
    });
  }

  void _loadFormationData() {
    final key = '${widget.matchDate}-${widget.opponent}';
    final formationData = ref.read(formationProvider)[key];
    if (formationData != null) {
      myGoodController.text = formationData.myGoodPoints;
      myBadController.text = formationData.myBadPoints;
      teamGoodController.text = formationData.teamGoodPoints;
      teamBadController.text = formationData.teamBadPoints;
    }
  }

  void _initializeFormation() {
    double xCenter = 180;
    final initialPositions = [
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
    final notifier = ref.read(formationProvider.notifier);
    for (int i = 0; i < initialPositions.length; i++) {
      notifier.updatePlayerPosition(
        widget.matchDate,
        widget.opponent,
        i,
        initialPositions[i],
      );
    }
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
    ref
        .read(formationProvider.notifier)
        .updatePlayerPosition(
          widget.matchDate,
          widget.opponent,
          index,
          Offset(clampedX - fieldOffset.dx, clampedY - fieldOffset.dy),
        );
    setState(() {
      _hasChanges = true;
    });
  }

  void _editPlayer(int index) {
    final key = '${widget.matchDate}-${widget.opponent}';
    // formationProvider から現在の選手名を取得
    final formationData = ref.read(formationProvider)[key]!;
    TextEditingController controller = TextEditingController(
      text: formationData.playerNames[index],
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('選手を編集'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: '名前'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 「自分に選択」ボタン：名前を更新し、該当選手を自分として登録（色を黒に）
                ref
                    .read(formationProvider.notifier)
                    .updatePlayerName(
                      widget.matchDate,
                      widget.opponent,
                      index,
                      controller.text,
                    );
                ref
                    .read(formationProvider.notifier)
                    .updatePlayerIsMyself(
                      widget.matchDate,
                      widget.opponent,
                      index,
                      true,
                    );
                Navigator.pop(context);
              },
              child: const Text('自分に選択'),
            ),
            TextButton(
              onPressed: () {
                // 「保存」ボタン：名前のみ更新
                ref
                    .read(formationProvider.notifier)
                    .updatePlayerName(
                      widget.matchDate,
                      widget.opponent,
                      index,
                      controller.text,
                    );
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    bool? save = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('保存確認'),
          content: const Text('変更を保存しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('破棄'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    if (save == true) {
      final key = '${widget.matchDate}-${widget.opponent}';
      final currentData = ref.read(formationProvider)[key];
      if (currentData != null) {
        final newData = currentData.copyWith(
          myGoodPoints: myGoodController.text,
          myBadPoints: myBadController.text,
          teamGoodPoints: teamGoodController.text,
          teamBadPoints: teamBadController.text,
        );
        ref
            .read(formationProvider.notifier)
            .updateFormation(widget.matchDate, widget.opponent, newData);
      }
      print('Changes saved.');
    } else {
      print('Changes discarded.');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final key = '${widget.matchDate}-${widget.opponent}';
    final formationData = ref.watch(formationProvider)[key]!;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'フォーメーション - ${widget.opponent}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
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
                    ...List.generate(11, (index) {
                      final pos = formationData.playerPositions[index];
                      return Positioned(
                        left: pos.dx,
                        top: pos.dy,
                        child: GestureDetector(
                          onLongPress: () => _editPlayer(index),
                          child: Draggable<int>(
                            data: index,
                            feedback: _buildPlayer(index, isDragging: true),
                            childWhenDragging: const SizedBox.shrink(),
                            child: _buildPlayer(index),
                          ),
                        ),
                      );
                    }),
                    Positioned.fill(
                      child: DragTarget<int>(
                        builder:
                            (context, candidateData, rejectedData) =>
                                Container(),
                        onAcceptWithDetails: (details) {
                          _updatePosition(details.data, details.offset);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildScoreBoard(formationData),
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard(FormationData formationData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildScoreColumn(
            "自チーム",
            formationData.myScore,
            () {
              ref
                  .read(formationProvider.notifier)
                  .updateMyScore(
                    widget.matchDate,
                    widget.opponent,
                    formationData.myScore + 1,
                  );
              setState(() {
                _hasChanges = true;
              });
            },
            () {
              if (formationData.myScore > 0) {
                ref
                    .read(formationProvider.notifier)
                    .updateMyScore(
                      widget.matchDate,
                      widget.opponent,
                      formationData.myScore - 1,
                    );
                setState(() {
                  _hasChanges = true;
                });
              }
            },
          ),
          const SizedBox(width: 40),
          _buildScoreColumn(
            "相手チーム",
            formationData.opponentScore,
            () {
              ref
                  .read(formationProvider.notifier)
                  .updateOpponentScore(
                    widget.matchDate,
                    widget.opponent,
                    formationData.opponentScore + 1,
                  );
              setState(() {
                _hasChanges = true;
              });
            },
            () {
              if (formationData.opponentScore > 0) {
                ref
                    .read(formationProvider.notifier)
                    .updateOpponentScore(
                      widget.matchDate,
                      widget.opponent,
                      formationData.opponentScore - 1,
                    );
                setState(() {
                  _hasChanges = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(
    String teamName,
    int score,
    VoidCallback onIncrease,
    VoidCallback onDecrease,
  ) {
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
              icon: const Icon(
                Icons.arrow_drop_up,
                size: 40,
                color: Colors.green,
              ),
            ),
            Text(
              '$score',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onDecrease,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 40,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildTextField(myGoodController, '自分の良い点'),
          _buildTextField(myBadController, '自分の反省点'),
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
        onChanged:
            (_) => setState(() {
              _hasChanges = true;
            }),
      ),
    );
  }

  Widget _buildPlayer(int index, {bool isDragging = false}) {
    final key = '${widget.matchDate}-${widget.opponent}';
    final formationData = ref.read(formationProvider)[key]!;
    final name = formationData.playerNames[index];
    final isMyself = formationData.isMyself[index];
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color:
            isMyself
                ? Colors.black
                : Colors.red.withOpacity(isDragging ? 0.5 : 1.0),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
