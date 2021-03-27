import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouistiti/di/Injection.dart';
import 'package:ouistiti/dto/OuistitiGameDetails.dart';
import 'package:ouistiti/dto/OuistitiGameToCreateOrJoin.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';
import 'package:ouistiti/socket/Socket.dart';
import 'package:ouistiti/util/PopResult.dart';
import 'package:ouistiti/util/error/JoinGameError.dart';
import 'package:ouistiti/viewmodel/JoinGameViewModel.dart';
import 'package:stacked/stacked.dart';

import 'InGameScreen.dart';
import 'arguments/JoinGameArguments.dart';

class CreateGameScreen extends StatefulWidget {
  static final String pageName = "/createGame";

  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  AppLocalizations i18n;

  final nicknameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

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
            child:
                /*ChangeNotifierProvider<JoinGameViewModel>.value(
                      value: getIt<JoinGameViewModel>(), builder: (context, _) {*/
                ViewModelBuilder<JoinGameViewModel>.reactive(
                    builder: (context, model, child) {
                      ////// HANDLE STREAMPROVIDERS //////
                      // joinGameError
                      String nicknameErrorMessage;
                      JoinGameError error = model
                          .joinGameError; //context.select((JoinGameViewModel vm) => vm.joinGameError);
                      if (error != null &&
                          error.errorType == JoinGameErrorType.NICKNAME_ERROR &&
                          error.errorMessageKey.isNotEmpty) {
                        nicknameErrorMessage =
                            i18n.translate(error.errorMessageKey);
                        print(
                            "joinGameError: nicknameErrorMessage: $nicknameErrorMessage");
                      }

                      // joinGameSuccess
                      OuistitiGameDetails chosenGame = model
                          .chosenGame; //context.select((JoinGameViewModel vm) => vm.chosenGame);
                      if (chosenGame != null) {
                        print("About to enter game");
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          print("Done rebuilding CreateGameScreen");
                          Navigator.of(context)
                              .pushNamed(InGameScreen.pageName,
                                  arguments: JoinGameArguments(chosenGame,
                                      nicknameTextFieldController.text))
                              .then((data) {
                            print("Returned to create game screen");
                            if (data is PopWithResults) {
                              print("data is PopWithResults");
                              PopWithResults popResult = data;
                              if (popResult.toPage ==
                                  CreateGameScreen.pageName) {
                                // ...
                              } else {
                                Navigator.of(context).pop(data);
                              }
                            }
                          });
                        });
                      }

                      ////// UI //////
                      return Column(
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
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: TextField(
                              controller: passwordTextFieldController,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 12, 12),
                                border: OutlineInputBorder(),
                                labelText: i18n
                                    .translate("password_field_create_game"),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                if (nicknameTextFieldController
                                    .text.isNotEmpty) {
                                  OuistitiGameToCreateOrJoin gameToCreate =
                                      OuistitiGameToCreateOrJoin(
                                          nickname:
                                              nicknameTextFieldController.text,
                                          password:
                                              passwordTextFieldController.text);
                                  print("Create game");
                                  getIt<Socket>().socketIO.emit(
                                      'createGame', gameToCreate.toJson());
                                } else {
                                  print("Error: please enter a nickname");
                                  /*context.read<JoinGameViewModel>()*/ model
                                      .showJoinGameError("error_no_nickname",
                                          JoinGameErrorType.NICKNAME_ERROR);
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 25.0,
                                    right: 25.0),
                                backgroundColor: Theme.of(context).primaryColor,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                              child: Text(
                                i18n.translate("create_button"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    viewModelBuilder: () => getIt<JoinGameViewModel>()),
          ),
        ),
      ),
    );
  }
}
