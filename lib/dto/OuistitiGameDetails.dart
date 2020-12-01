import 'package:flutter/cupertino.dart';

import 'OuistitiPlayer.dart';

class OuistitiGameDetails {
  const OuistitiGameDetails(
      {@required this.id,
      @required this.totalCardCount,
      @required this.totalRoundCount,
      @required this.firstPlayerId,
      @required this.players,
      @required this.playerIdOrder});

  final String id;
  final int totalCardCount;
  final int totalRoundCount;
  final String firstPlayerId;
  final List<OuistitiPlayer> players;
  final List<String> playerIdOrder;

  static OuistitiGameDetails fromMap(Map<String, dynamic> data) {
    List<OuistitiPlayer> playersList = new List<OuistitiPlayer>();
    data["players"].asMap().forEach((key, value) {
      playersList.add(OuistitiPlayer.fromMap(value));
    });
    List<String> playerIdOrderList = new List<String>();
    data["playerIdOrder"].asMap().forEach((key, value) {
      playerIdOrderList.add(value);
    });
    return OuistitiGameDetails(
        id: data["id"],
        totalCardCount: data["totalCardCount"],
        totalRoundCount: data["totalRoundCount"],
        firstPlayerId: data["firstPlayerId"],
        players: playersList, //data["players"].forEach((key, value) {}),
        playerIdOrder: playerIdOrderList);
  }

  @override
  String toString() {
    return "Game ID ${this.id}";
  }
}
