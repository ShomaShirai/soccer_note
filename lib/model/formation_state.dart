import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FormationData {
  final List<Offset> playerPositions;
  final int myScore;
  final int opponentScore;
  final String myGoodPoints;
  final String myBadPoints;
  final String teamGoodPoints;
  final String teamBadPoints;
  final String matchDate;  // 試合日時
  final String opponent;   // 対戦相手
  final List<String> playerNames;  // 各選手の名前
  final List<bool> isMyself;       // 各選手が自分かどうか

  FormationData({
    required this.playerPositions,
    required this.myScore,
    required this.opponentScore,
    required this.myGoodPoints,
    required this.myBadPoints,
    required this.teamGoodPoints,
    required this.teamBadPoints,
    required this.matchDate,
    required this.opponent,
    required this.playerNames,
    required this.isMyself,
  });

  FormationData copyWith({
    List<Offset>? playerPositions,
    int? myScore,
    int? opponentScore,
    String? myGoodPoints,
    String? myBadPoints,
    String? teamGoodPoints,
    String? teamBadPoints,
    String? matchDate,
    String? opponent,
    List<String>? playerNames,
    List<bool>? isMyself,
  }) {
    return FormationData(
      playerPositions: playerPositions ?? this.playerPositions,
      myScore: myScore ?? this.myScore,
      opponentScore: opponentScore ?? this.opponentScore,
      myGoodPoints: myGoodPoints ?? this.myGoodPoints,
      myBadPoints: myBadPoints ?? this.myBadPoints,
      teamGoodPoints: teamGoodPoints ?? this.teamGoodPoints,
      teamBadPoints: teamBadPoints ?? this.teamBadPoints,
      matchDate: matchDate ?? this.matchDate,
      opponent: opponent ?? this.opponent,
      playerNames: playerNames ?? this.playerNames,
      isMyself: isMyself ?? this.isMyself,
    );
  }
}

class FormationNotifier extends StateNotifier<Map<String, FormationData>> {
  FormationNotifier() : super({});

  String _generateKey(String matchDate, String opponent) {
    return '$matchDate-$opponent';
  }

  void initializeFormation(String matchDate, String opponent) {
    final key = _generateKey(matchDate, opponent);
    if (!state.containsKey(key)) {
      state = {
        ...state,
        key: FormationData(
          playerPositions: List.generate(11, (index) => Offset.zero),
          myScore: 0,
          opponentScore: 0,
          myGoodPoints: '',
          myBadPoints: '',
          teamGoodPoints: '',
          teamBadPoints: '',
          matchDate: matchDate,
          opponent: opponent,
          playerNames: List.generate(11, (index) => '${index + 1}'),
          isMyself: List.generate(11, (_) => false),
        ),
      };
    }
  }

  void updatePlayerPosition(String matchDate, String opponent, int index, Offset position) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      final updatedPositions = List<Offset>.from(data.playerPositions);
      updatedPositions[index] = position;
      state = {
        ...state,
        key: data.copyWith(playerPositions: updatedPositions),
      };
    }
  }

  void updateMyScore(String matchDate, String opponent, int newScore) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      state = {
        ...state,
        key: data.copyWith(myScore: newScore),
      };
    }
  }

  void updateOpponentScore(String matchDate, String opponent, int newScore) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      state = {
        ...state,
        key: data.copyWith(opponentScore: newScore),
      };
    }
  }

  void updateMyGoodPoints(String matchDate, String opponent, String text) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      state = {
        ...state,
        key: data.copyWith(myGoodPoints: text),
      };
    }
  }

  void updateMyBadPoints(String matchDate, String opponent, String text) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      state = {
        ...state,
        key: data.copyWith(myBadPoints: text),
      };
    }
  }

  void updateTeamGoodPoints(String matchDate, String opponent, String text) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      state = {
        ...state,
        key: data.copyWith(teamGoodPoints: text),
      };
    }
  }

  void updateTeamBadPoints(String matchDate, String opponent, String text) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      state = {
        ...state,
        key: data.copyWith(teamBadPoints: text),
      };
    }
  }

  void updatePlayerName(String matchDate, String opponent, int index, String newName) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      final updatedNames = List<String>.from(data.playerNames);
      updatedNames[index] = newName;
      state = {
        ...state,
        key: data.copyWith(playerNames: updatedNames),
      };
    }
  }

  void updatePlayerIsMyself(String matchDate, String opponent, int index, bool isMyself) {
    final key = _generateKey(matchDate, opponent);
    if (state.containsKey(key)) {
      final data = state[key]!;
      final updatedIsMyself = List<bool>.from(data.isMyself);
      updatedIsMyself[index] = isMyself;
      state = {
        ...state,
        key: data.copyWith(isMyself: updatedIsMyself),
      };
    }
  }

  void updateFormation(String matchDate, String opponent, FormationData newData) {
    final key = _generateKey(matchDate, opponent);
    state = {
      ...state,
      key: newData,
    };
  }
}

final formationProvider = StateNotifierProvider<FormationNotifier, Map<String, FormationData>>((ref) {
  return FormationNotifier();
});
