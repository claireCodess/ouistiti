import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Fonts
  static const _kFontFam = 'OuistitiApp';
  static const _kFontPkg = null;

  static const IconData wrench =
      IconData(0xe867, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData door_open =
      IconData(0xf52b, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

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
          body: Stack(
            children: <Widget>[
              AlignPositioned.relative(
                  Center(
                      child: Text(i18n.translate("waiting_for_players"),
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0))),
                  TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          backgroundColor: Theme.of(context).primaryColor,
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      child: Text(i18n.translate("start_game_button"),
                          style:
                              TextStyle(color: Colors.white, fontSize: 22.0))),
                  moveByChildHeight: 1.0),
              Positioned(
                  top: 16, left: 16, child: Icon(wrench, color: Colors.white)),
              Positioned(
                  bottom: 16,
                  left: 16,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person, color: Colors.white),
                        Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text("Claire",
                                style: TextStyle(color: Colors.white))),
                        Padding(
                            padding: EdgeInsets.only(left: 8),
                            child:
                                Icon(Icons.create_sharp, color: Colors.white))
                      ])),
              Positioned(
                  bottom: 16,
                  right: 16,
                  child: Icon(door_open, color: Colors.white)),
            ],
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
