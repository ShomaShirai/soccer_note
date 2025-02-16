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
