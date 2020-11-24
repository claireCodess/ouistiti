import 'package:flutter/cupertino.dart';

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
  final String /*List<Player>*/ players;
  final int playerIdOrder;

  static OuistitiGameDetails fromMap(Map<String, dynamic> data) {
    return OuistitiGameDetails(
        id: data["id"],
        totalCardCount: data["totalCardCount"],
        totalRoundCount: data["totalRoundCount"],
        firstPlayerId: data["firstPlayerId"],
        players: data["players"],
        playerIdOrder: data["playerIdOrder"]);
  }
}
