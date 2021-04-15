import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inject/inject.dart';
import 'package:ouistiti/bloc/list_games_bloc.dart';
import 'package:ouistiti/di/get_it/Injection.dart';
import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:ouistiti/dto/OuistitiGameDetails.dart';
import 'package:ouistiti/dto/OuistitiGameToCreateOrJoin.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';
import 'package:ouistiti/socket/Socket.dart';
import 'package:ouistiti/util/PopResult.dart';
import 'package:ouistiti/util/error/JoinGameError.dart';
import 'package:ouistiti/viewmodel/JoinGameViewModel.dart';
import 'package:ouistiti/widget/screen/CreateGameScreen.dart';
import 'package:sprintf/sprintf.dart';
import 'package:stacked/stacked.dart';

import 'InGameScreen.dart';
import 'arguments/JoinGameArguments.dart';

@provide
class SelectGameScreen extends StatefulWidget {
  final ListGamesBloc bloc;
  SelectGameScreen({Key key, this.bloc}) : super(key: key);

  static final String pageName = "/selectGame";

  @override
  _SelectGameScreenState createState() => _SelectGameScreenState();
}

class _SelectGameScreenState extends State<SelectGameScreen> {
  AppLocalizations i18n;
  double height, width;

  final nicknameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Done loading widget");
    });
  }

  /*
   * START WIDGETS
   */

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    i18n = AppLocalizations.of(context);

    print("Build main widget");
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.translate("select_game_title")),
      ),
      body: Center(
          child: BlocProvider(
        create: (context) => widget.bloc,
        child: BlocBuilder<ListGamesBloc, ListGamesState>(
            builder: (context, state) {
          print("Need to rebuild");
          if (state is ListGamesSuccess) {
            print(
                "Rebuild UI with ${state.listGames.length} games in the list");
            return buildListGames(state.listGames);
          } else if (state is ListGamesLoading) {
            return buildLoading();
          } else if (state is ListGamesInitial) {
            // Init socket connection
            widget.bloc.add(InitSocketConnection());
            // And return empty container
            return Container();
          } else {
            // Just return empty container
            return Container();
          }
        }),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorDark,
        onPressed: () {
          Navigator.of(context)
              .pushNamed(CreateGameScreen.pageName)
              .then((data) {
            if (data is PopWithResults) {
              disconnectPlayerAfterLeavingGame(data, context);
            }
          });
        },
        tooltip: 'Create game',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildListGames(List<OuistitiGame> listGames) {
    print("Rebuilding list of games...with ${listGames.length} games");
    return Container(
        padding: EdgeInsets.only(top: 20),
        height: height,
        width: width,
        child: ListView.builder(
          itemCount: listGames.length,
          itemBuilder: (BuildContext context, int index) {
            OuistitiGame game = listGames[index];
            Color gameColor;
            if (game.inProgress || !game.joinable) {
              gameColor = Theme.of(context).primaryColorLight;
            } else {
              gameColor = Theme.of(context).primaryColor;
            }
            return Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: Material(
                    color: gameColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: InkWell(
                        onTap: () {
                          if (game.inProgress) {
                            showErrorMessageSnackBar(
                                i18n.translate("error_game_in_progress"));
                          } else if (!game.joinable) {
                            showErrorMessageSnackBar(
                                i18n.translate("error_game_full"));
                          } else {
                            // The player can access the dialog to enter
                            // nickname and maybe password
                            createJoinGameAlertDialog(
                                    context, game.id, game.hostNickname)
                                .then((data) {
                              if (data is PopWithResults) {
                                disconnectPlayerAfterLeavingGame(data, context);
                              } else if (data is JoinGameError) {
                                showErrorMessageSnackBar(
                                    i18n.translate(data.errorMessageKey));
                              }
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              isThreeLine: true,
                              leading: Icon(Icons.videogame_asset,
                                  size: 28.0, color: Colors.white),
                              title: Text(game.hostNickname,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              subtitle: Text(
                                  "${game.inProgress ? "${i18n.translate("inProgress")}\n${i18n.translate("round")}" : (game.joinable ? "${i18n.translate("joinable")}${game.passwordProtected ? "\n${i18n.translate("password_protected")}" : ''}" : i18n.translate("full"))}",
                                  style: TextStyle(color: Colors.white)),
                              trailing: Text(
                                  "${game.playersCount.toString()} "
                                  "${i18n.translate("player")}"
                                  "${game.playersCount > 1 ? 's' : ''}",
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.white))),
                        ))));
          },
        ));
  }

  Widget buildLoading() {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  /*
   * END WIDGETS
   */

  void disconnectPlayerAfterLeavingGame(
      PopWithResults popResult, BuildContext context) {
    if (popResult != null) {
      if (popResult.toPage == SelectGameScreen.pageName) {
        if (popResult.fromPage == InGameScreen.pageName) {
          // For the moment, disconnect to "force leave game"
          // and then reconnect.
          getIt<Socket>().socketIO.disconnect();
          getIt<Socket>().socketIO.connect();
        }
      }
    }
  }

  showErrorMessageSnackBar(String errorMessage) {
    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(errorMessage),
              Icon(Icons.error, color: Colors.white)
            ],
          ),
          backgroundColor: Colors.red,
        ));
    }
  }

  createJoinGameAlertDialog(
      BuildContext context, String gameId, String hostNickname) {
    return showDialog(
        context: context,
        builder: (context) {
          return /*MultiProvider(
              providers: [
                ChangeNotifierProvider<JoinGameViewModel>.value(
                    value: getIt<JoinGameViewModel>()),
                StreamProvider<OuistitiGameDetails>.value(
                    value: getIt<Socket>().chosenGameToStream)
              ],
              child: Builder(builder: (BuildContext context) {*/
              ViewModelBuilder<JoinGameViewModel>.reactive(
                  builder: (context, model, child) {
                    ////// HANDLE STREAMPROVIDERS //////
                    // joinGameError
                    String nicknameErrorMessage;
                    String passwordErrorMessage;
                    JoinGameError error = model
                        .joinGameError; //context.select((JoinGameViewModel vm) => vm.joinGameError);
                    if (error != null && error.errorMessageKey.isNotEmpty) {
                      if (error.errorType == JoinGameErrorType.NICKNAME_ERROR) {
                        nicknameErrorMessage =
                            i18n.translate(error.errorMessageKey);
                        passwordErrorMessage = null;
                      } else if (error.errorType ==
                          JoinGameErrorType.PASSWORD_ERROR) {
                        passwordErrorMessage =
                            i18n.translate(error.errorMessageKey);
                        nicknameErrorMessage = null;
                      } else {
                        // OTHER_ERROR
                        Navigator.of(context).pop(error);
                      }
                    }

                    // joinGameSuccess
                    OuistitiGameDetails chosenGame = model
                        .chosenGame; //context.select((JoinGameViewModel vm) => vm.chosenGame);
                    if (chosenGame != null) {
                      print("About to enter game");
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        print("Done rebuilding JoinGameAlertDialog");
                        Navigator.of(context)
                            .pushNamed(InGameScreen.pageName,
                                arguments: JoinGameArguments(chosenGame,
                                    nicknameTextFieldController.text))
                            .then((data) {
                          print(
                              "Returned to select game screen - close join game dialog");
                          if (data is PopWithResults) {
                            print("data is PopWithResults");
                          }
                          Navigator.of(context).pop(data);
                        });
                      });
                    }

                    ////// UI //////
                    return AlertDialog(
                        scrollable: true,
                        title: Text(sprintf(
                            i18n.translate("join_game_dialog_title"),
                            [hostNickname])),
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
                                      labelText:
                                          i18n.translate("nickname_field"),
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
                                        .translate("password_field_join_game"),
                                    errorText: passwordErrorMessage),
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
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
                              i18n.translate("join_button"),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                            onPressed: () {
                              if (nicknameTextFieldController.text.isNotEmpty) {
                                OuistitiGameToCreateOrJoin gameToJoin =
                                    OuistitiGameToCreateOrJoin(
                                        id: gameId,
                                        nickname:
                                            nicknameTextFieldController.text,
                                        password:
                                            passwordTextFieldController.text);
                                print("Join game");
                                getIt<Socket>()
                                    .socketIO
                                    .emit('joinGame', gameToJoin.toJson());
                              } else {
                                print("Error: please enter a nickname");
                                /*context.read<JoinGameViewModel>()*/ model
                                    .showJoinGameError("error_no_nickname",
                                        JoinGameErrorType.NICKNAME_ERROR);
                              }
                            },
                          ),
                        ]);
                  },
                  viewModelBuilder: () => getIt<JoinGameViewModel>());
        },
        barrierDismissible:
            true); // The player can choose to press outside of the alert dialog to not join the game
  }
}
