import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:ouistiti/dto/OuistitiGameToCreateOrJoin.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';
import 'package:ouistiti/model/GamesModel.dart';
import 'package:ouistiti/util/PopResult.dart';
import 'package:ouistiti/widget/screen/CreateGameScreen.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

import '../../main.dart';
import 'InGameScreen.dart';

class SelectGameScreen extends StatefulWidget {
  SelectGameScreen({Key key}) : super(key: key);

  static final String pageName = "/selectGame";

  @override
  _SelectGameScreenState createState() => _SelectGameScreenState();
}

class _SelectGameScreenState extends State<SelectGameScreen> {
  AppLocalizations i18n;
  double height, width;

  final nicknameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Done loading widget");
      Provider.of<GamesModel>(context, listen: false)
          .initSocketAndEstablishConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    i18n = AppLocalizations.of(context);

    print("Build main widget");
    /*return Provider<String>.value(
        value: Provider.of<GamesModel>(context).errorMessage,
        builder: (context, child) {
          handleErrorMessageSnackBar(context);*/
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(i18n.translate("select_game_title")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8)),
            Container(
              height: height * 0.7,
              width: width,
              child: StreamProvider<List<OuistitiGame>>.value(
                value: Provider.of<GamesModel>(context).listGamesToStream,
                builder: (context, child) {
                  print("Need to rebuild");
                  return buildColumnWithData(
                      context.watch<List<OuistitiGame>>());
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(CreateGameScreen.pageName)
              .then((data) {
            disconnectPlayerAfterLeavingGame(data, context);
          });
        },
        tooltip: 'Create game',
        child: Icon(Icons.add),
      ),
    );
    //});
  }

  void disconnectPlayerAfterLeavingGame(Object data, BuildContext context) {
    PopWithResults popResult = data as PopWithResults;
    if (popResult != null) {
      if (popResult.toPage == SelectGameScreen.pageName) {
        if (popResult.fromPage == InGameScreen.pageName) {
          // For the moment, disconnect to "force leave game"
          // and then reconnect.
          Provider.of<GamesModel>(context, listen: false).socketIO.disconnect();
          Provider.of<GamesModel>(context, listen: false).socketIO.connect();
        }
      }
    }
  }

  /*
   * START WIDGETS
   */

  Widget buildColumnWithData(List<OuistitiGame> listGames) {
    if (listGames == null) {
      return buildLoading();
    } else {
      print("Rebuilding list of games...with ${listGames.length} games");
      return ListView.builder(
        itemCount: listGames.length,
        itemBuilder: (BuildContext context, int index) {
          OuistitiGame game = listGames[index];
          return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Material(
                  color: MaterialColor(0xff86A186, primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: InkWell(
                      onTap: () {
                        if (game.inProgress) {
                          showErrorMessageSnackBar("Game already in progress");
                        } else if (!game.joinable) {
                          showErrorMessageSnackBar(
                              "No more players can join this game");
                        } else {
                          // The player can access the dialog to enter
                          // nickname and maybe password
                          createJoinGameAlertDialog(
                                  context, game.id, game.hostNickname)
                              .then((data) {
                            disconnectPlayerAfterLeavingGame(data, context);
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
      );
    }
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  showErrorMessageSnackBar(String errorMessage) {
    if (_scaffoldKey.currentState != null) {
      if (errorMessage.isNotEmpty) {
        _scaffoldKey.currentState
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(errorMessage), Icon(Icons.error)],
            ),
            backgroundColor: Colors.red,
          ));
      }
    }
  }

  /*
   * END WIDGETS
   */

  createJoinGameAlertDialog(
      BuildContext context, String gameId, String hostNickname) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              scrollable: true,
              title: Text(sprintf(
                  i18n.translate("join_game_dialog_title"), [hostNickname])),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: StreamProvider<String>.value(
                        value: Provider.of<GamesModel>(context)
                            .errorMessageToStream,
                        builder: (context, child) {
                          String errorMessage;
                          String streamedData = context.watch<String>();
                          if (streamedData != null && streamedData.isNotEmpty) {
                            errorMessage = streamedData;
                          } else {
                            errorMessage = null;
                          }
                          return TextField(
                            controller: nicknameTextFieldController,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 12, 12),
                                border: OutlineInputBorder(),
                                labelText: i18n.translate("nickname_field"),
                                errorText: errorMessage),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: passwordTextFieldController,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                        border: OutlineInputBorder(),
                        labelText: i18n.translate("password_field_join_game"),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                    backgroundColor: MaterialColor(0xff86A186, primaryColor),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  child: Text(
                    i18n.translate("join_button"),
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  onPressed: () {
                    if (nicknameTextFieldController.text.isNotEmpty) {
                      OuistitiGameToCreateOrJoin gameToJoin =
                          OuistitiGameToCreateOrJoin(
                              id: gameId,
                              nickname: nicknameTextFieldController.text,
                              password: passwordTextFieldController.text);
                      print("Join game");
                      Provider.of<GamesModel>(context, listen: false)
                          .socketIO
                          .emit('joinGame', gameToJoin.toJson());
                    } else {
                      print("Error: please enter a nickname");
                      context
                          .read<GamesModel>()
                          .showError("Please enter a nickname");
                    }
                    /* /////// TEMPORARILY DISABLED ///////
                      Navigator.of(context)
                        .pushNamed(InGameScreen.pageName)
                        .then((data) {
                      print(
                          "Returned to select game screen - close join game dialog");
                      if (data is PopWithResults) {
                        print("data is PopWithResults");
                      }
                      Navigator.of(context).pop(data);
                    });*/
                  },
                ),
              ]);
        },
        barrierDismissible:
            true); // The player can choose to press outside of the alert dialog to not join the game
  }
}
