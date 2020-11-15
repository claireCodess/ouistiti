import 'package:flutter/cupertino.dart';

class OuistitiGameToCreate {
  const OuistitiGameToCreate(
      {@required this.nickname, @required this.password});

  final String nickname;
  final String password;

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'password': password,
      };
}
