import 'package:flutter/cupertino.dart';

class OuistitiGameToCreateOrJoin {
  const OuistitiGameToCreateOrJoin(
      {this.id, @required this.nickname, @required this.password});

  final String nickname;
  final String password;
  final String id;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'password': password,
      };
}
