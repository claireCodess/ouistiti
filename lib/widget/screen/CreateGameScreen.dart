import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';
import 'package:ouistiti/model/OuistitiGameToCreate.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../main.dart';

AppLocalizations i18n;

class CreateGameScreen extends StatefulWidget {
  IO.Socket socketIO;

  CreateGameScreen(BuildContext context,
      IO.Socket socketIO /* Not good practise but will do for the moment */) {
    this.socketIO = socketIO;
  }

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState(this.socketIO);
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  IO.Socket socketIO;
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nicknameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  _CreateGameScreenState(IO.Socket socketIO) {
    this.socketIO = socketIO;
  }

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.translate("create_game_title")),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 12),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: nicknameTextFieldController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: i18n.translate("nickname_field"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: passwordTextFieldController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: i18n.translate("password_field"),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      OuistitiGameToCreate gameToCreate = OuistitiGameToCreate(
                          nickname: nicknameTextFieldController.text,
                          password: passwordTextFieldController.text);
                      socketIO.emit('createGame', gameToCreate.toJson());
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                      backgroundColor: MaterialColor(0xff86A186, primaryColor),
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    child: Text(
                      i18n.translate("create_button"),
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
