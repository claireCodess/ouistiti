import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ouistiti/di/Injection.dart';
import 'package:ouistiti/dto/OuisitiSetNickname.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';
import 'package:ouistiti/socket/Socket.dart';
import 'package:ouistiti/util/PopResult.dart';
import 'package:ouistiti/util/error/NicknameError.dart';
import 'package:ouistiti/widget/screen/arguments/JoinGameArguments.dart';
import 'package:provider/provider.dart';

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    final JoinGameArguments joinGameArgs =
        ModalRoute.of(context).settings.arguments;
    bool isHost =
        joinGameArgs.gameDetails.hostId == joinGameArgs.gameDetails.selfId;
    String nickname = joinGameArgs.nickname;

    return StreamProvider<String>(
        create: (_) => getIt<Socket>().nicknameToStream,
        initialData: nickname,
        builder: (context, _) {
          return WillPopScope(
              child: Scaffold(
                backgroundColor: MaterialColor(0xFF366336, boardColor),
                body: Stack(
                  children: <Widget>[
                    AlignPositioned.relative(
                        Center(
                            child: Text(i18n.translate("waiting_for_players"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0))),
                        Visibility(
                            visible: isHost,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                        left: 25.0,
                                        right: 25.0),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                                child: Text(i18n.translate("start_game_button"),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22.0)))),
                        moveByChildHeight: 1.0),
                    Visibility(
                        visible: isHost,
                        child: Positioned(
                            top: 16,
                            left: 16,
                            child: Icon(wrench, color: Colors.white))),
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
                                  child: Text(context.watch<String>(),
                                      style: TextStyle(color: Colors.white))),
                              Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: GestureDetector(
                                      child: Icon(Icons.create_sharp,
                                          color: Colors.white),
                                      onTap: () {
                                        createModifyPlayerInfoDialog(
                                                context, nickname)
                                            .then((newNickname) {
                                          if (newNickname is String) {
                                            nickname = newNickname;
                                          }
                                        });
                                      }))
                            ])),
                    Positioned(
                        bottom: 16,
                        right: 16,
                        child: GestureDetector(
                            child: Icon(door_open, color: Colors.white),
                            onTap: () {
                              _requestPop();
                            })),
                  ],
                ),
              ),
              onWillPop: _requestPop);
        });
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

  createModifyPlayerInfoDialog(BuildContext context, String originalNickname) {
    final nicknameTextFieldController = TextEditingController();
    nicknameTextFieldController.text = originalNickname;

    return showDialog(
        context: context,
        builder: (context) {
          return MultiProvider(
              providers: [
                StreamProvider<NicknameError>.value(
                    value: getIt<Socket>()
                        .nicknameErrorMsgToStream),
                StreamProvider<String>.value(
                    value: getIt<Socket>().nicknameToStream)
              ],
              child: Builder(builder: (BuildContext context) {
                ////// HANDLE STREAMPROVIDERS //////
                // nicknameError
                String nicknameErrorMessage;
                NicknameError nicknameErrorDto = context.watch<NicknameError>();
                if (nicknameErrorDto != null &&
                    nicknameErrorDto.errorMessageKey.isNotEmpty) {
                  nicknameErrorMessage =
                      i18n.translate(nicknameErrorDto.errorMessageKey);
                }

                // nicknameSuccess
                String nickname = context.watch<String>();
                if (nickname != null) {
                  print("Nickname changed successfully to: $nickname");
                  Navigator.of(context).pop(nickname);
                }

                ////// UI //////
                return AlertDialog(
                    scrollable: true,
                    title: Text(i18n.translate("modify_player_info")),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: TextField(
                              controller: nicknameTextFieldController,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12, 12, 12, 12),
                                  border: OutlineInputBorder(),
                                  labelText: i18n.translate("nickname_field"),
                                  errorText: nicknameErrorMessage),
                              maxLength: 20,
                            )),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                          backgroundColor: Theme.of(context).primaryColor,
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        child: Text(
                          i18n.translate("modify_button"),
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                        onPressed: () {
                          String nickname = nicknameTextFieldController.text;
                          if (nickname.isNotEmpty &&
                              nickname != originalNickname) {
                            print("Changing nickname to $nickname");
                            getIt<Socket>()
                                .socketIO
                                .emit('setNickname',
                                    OuistitiSetNickname(nickname).toJson());
                          } else if (nickname.isEmpty) {
                            print("Error: please enter a nickname");
                            context
                                .read<Socket>()
                                .showNicknameError("error_no_nickname");
                          }
                        },
                      ),
                    ]);
              }));
        },
        barrierDismissible:
            true); // The player can choose to press outside of the alert dialog to not join the game
  }
}
