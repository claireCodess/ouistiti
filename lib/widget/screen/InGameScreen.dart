import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Future<PopWithResults> createLeaveGameAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Leave game"),
              content: Text("Are you sure you want to leave the game?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    // Close the dialog AND transfer PopWithResults to pop directly back
                    // to the select game screen
                    Navigator.of(context).pop(PopWithResults(
                        fromPage: InGameScreen.pageName,
                        toPage: SelectGameScreen.pageName));
                    /*Navigator.of(context)
                        .popUntil(ModalRoute.withName('/selectGame'));*/
                  },
                ),
                FlatButton(
                    child: Text("No"),
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
    return WillPopScope(
        child: Scaffold(
          backgroundColor: MaterialColor(0xff366336, boardColor),
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
