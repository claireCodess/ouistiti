import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';

import '../../main.dart';

AppLocalizations i18n;

class CreateGameScreen extends StatefulWidget {
  CreateGameScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: i18n.translate("nickname_field"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
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
                    onPressed: () {},
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
