import 'package:flutter/cupertino.dart';

class OuistitiGame {
  const OuistitiGame(
      {this.id,
        @required this.inProgress,
        @required this.joinable,
        @required this.passwordProtected,
        @required this.playersCount,
        @required this.hostId,
        @required this.hostNickname,
        @required this.hostColour,
        @required this.round,
        @required this.totalRoundCount});

    final String id;
    final bool inProgress;
    final bool joinable;
    final bool passwordProtected;
    final int playersCount;
    final String hostId;
    final String hostNickname;
    final String hostColour;
    final int round;
    final int totalRoundCount;

    static OuistitiGame fromMap(Map<String, dynamic> data) {
      return OuistitiGame(
          id: data["id"],
          inProgress: data["inProgress"],
          joinable: data["joinable"],
          passwordProtected: data["passwordProtected"],
          playersCount: data["playersCount"],
          hostId: data["hostId"],
          hostNickname: data["hostNickname"],
          hostColour: data["hostColour"],
          round: data["round"],
          totalRoundCount: data["totalRoundCount"]);
  }
}