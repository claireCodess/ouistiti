import 'package:flutter/cupertino.dart';

class OuistitiGetNickname {
    const OuistitiGetNickname(
    {this.id, @required this.oldNickname, @required this.newNickname});

    final String id;
    final String oldNickname;
    final String newNickname;

    static OuistitiGetNickname fromMap(Map<String, dynamic> data) {
        return OuistitiGetNickname(
            id: data["id"], oldNickname: data["oldNickname"], newNickname: data["newNickname"]);
    }
}
