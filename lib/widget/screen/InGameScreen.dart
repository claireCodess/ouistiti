import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';
import 'package:ouistiti/util/PopResult.dart';

import '../../main.dart';
import 'SelectGameScreen.dart';

class InGameScreen extends StatefulWidget {
  InGameScreen({Key key}) : super(key: key);

  static final String pageName = "/inGame";

  @override
  _InGameScreenState createState() => _InGameScreenState();
}

class _InGameScreenState extends State<InGameScreen> {
  AppLocalizations i18n;

  Future<PopWithResults> createLeaveGameAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(i18n.translate("leave_game_dialog_title")),
              content: Text(i18n.translate("leave_game_dialog_message")),
              actions: <Widget>[
                FlatButton(
                  child: Text(i18n.translate("yes")),
                  onPressed: () {
                    // Close the dialog AND transfer PopWithResults to pop directly back
                    // to the select game screen
                    Navigator.of(context).pop(PopWithResults(
                        fromPage: InGameScreen.pageName,
                        toPage: SelectGameScreen.pageName));
                  },
                ),
                FlatButton(
                    child: Text(i18n.translate("no")),
                    onPressed: () {
                      // Just close the dialog
                      Navigator.of(context).pop();
                    })
              ]);
        },
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    i18n = AppLocalizations.of(context);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: MaterialColor(0xFF366336, boardColor),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    print("requestPop");
    createLeaveGameAlertDialog(context).then((onValue) {
      if (onValue != null) {
        print("Player has decided to leave the game");
        Navigator.of(context).pop(onValue);
      } else {
        print("Player has decided not to leave the game");
      }
    });
    return new Future.value(false);
  }
}
