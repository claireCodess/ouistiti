import 'package:flutter/cupertino.dart';

import 'OuistitiPlayer.dart';

class OuistitiGameDetails {
  const OuistitiGameDetails(
      {@required this.id,
      @required this.totalCardCount,
      @required this.totalRoundCount,
      @required this.players,
      @required this.playerIdOrder,
      @required this.selfId,
      @required this.hostId});

  final String id;
  final int totalCardCount;
  final int totalRoundCount;
  final List<OuistitiPlayer> players;
  final List<String> playerIdOrder;
  final String selfId;
  final String hostId;

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
      players: playersList,
      playerIdOrder: playerIdOrderList,
      selfId: data["selfId"],
      hostId: data["hostId"],
    );
  }

  @override
  String toString() {
    return "Details of game with ID: ${this.id}\nTotal card count: ${this.totalCardCount}\n" +
        "Total round count: ${this.totalRoundCount}\nNumber of players: ${this.players.length}\n" +
        "selfId: ${this.selfId}\nhostId: ${this.hostId}\n";
  }
}
