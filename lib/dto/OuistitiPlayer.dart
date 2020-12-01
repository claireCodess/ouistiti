import 'package:flutter/cupertino.dart';

class OuistitiPlayer {
  const OuistitiPlayer(
      {@required this.id, @required this.nickname, @required this.colour});

  final String id;
  final String nickname;
  final String colour;

  static OuistitiPlayer fromMap(Map<String, dynamic> data) {
    return OuistitiPlayer(
        id: data["id"], nickname: data["nickname"], colour: data["colour"]);
  }
}
