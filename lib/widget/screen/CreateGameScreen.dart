import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouistiti/dto/OuistitiGameToCreate.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';
import 'package:ouistiti/model/GamesModel.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

AppLocalizations i18n;

class CreateGameScreen extends StatefulWidget {
  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nicknameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context);
    return new WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
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
                        OuistitiGameToCreate gameToCreate =
                            OuistitiGameToCreate(
                                nickname: nicknameTextFieldController.text,
                                password: passwordTextFieldController.text);
                        print("create game");
                        Provider.of<GamesModel>(context, listen: false)
                            .socketIO
                            .emit('createGame', gameToCreate.toJson());
                        Navigator.of(context).pop(true); // true = game created
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                        backgroundColor:
                            MaterialColor(0xff86A186, primaryColor),
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
      ),
    );
  }

  Future<bool> _requestPop() {
    print("requestPop");
    Navigator.of(context).pop(false); // false = game not created
    return new Future.value(false);
  }
}