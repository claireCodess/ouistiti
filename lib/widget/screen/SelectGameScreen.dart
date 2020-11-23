import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:ouistiti/i18n/AppLocalizations.dart';
import 'package:ouistiti/model/GamesModel.dart';
import 'package:ouistiti/util/PopResult.dart';
import 'package:ouistiti/widget/screen/CreateGameScreen.dart';
import 'package:provider/provider.dart';

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print("Build main widget");
    return Scaffold(
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
            PopWithResults popResult = data as PopWithResults;
            if (popResult != null) {
              if (popResult.toPage == SelectGameScreen.pageName) {
                if (popResult.fromPage == InGameScreen.pageName) {
                  // For the moment, disconnect to "force leave game"
                  // and then reconnect.
                  Provider.of<GamesModel>(context, listen: false)
                      .socketIO
                      .disconnect();
                  Provider.of<GamesModel>(context, listen: false)
                      .socketIO
                      .connect();
                }
              } else {
                Navigator.of(context).pop(data);
              }
            }
          });
        },
        tooltip: 'Create game',
        child: Icon(Icons.add),
      ),
    );
  }

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
                      onTap: () {},
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
}
