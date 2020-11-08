import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ouistiti/widget/screen/CreateGameScreen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'i18n/AppLocalizations.dart';
import 'model/OuistitiGame.dart';

void main() {
  runApp(OuistitiApp());
}

Map<int, Color> boardColor = {
  50: Color.fromRGBO(54, 99, 54, .1),
  100: Color.fromRGBO(54, 99, 54, .2),
  200: Color.fromRGBO(54, 99, 54, .3),
  300: Color.fromRGBO(54, 99, 54, .4),
  400: Color.fromRGBO(54, 99, 54, .5),
  500: Color.fromRGBO(54, 99, 54, .6),
  600: Color.fromRGBO(54, 99, 54, .7),
  700: Color.fromRGBO(54, 99, 54, .8),
  800: Color.fromRGBO(54, 99, 54, .9),
  900: Color.fromRGBO(54, 99, 54, 1),
};

Map<int, Color> primaryColor = {
  50: Color.fromRGBO(134, 161, 134, .1),
  100: Color.fromRGBO(134, 161, 134, .2),
  200: Color.fromRGBO(134, 161, 134, .3),
  300: Color.fromRGBO(134, 161, 134, .4),
  400: Color.fromRGBO(134, 161, 134, .5),
  500: Color.fromRGBO(134, 161, 134, .6),
  600: Color.fromRGBO(134, 161, 134, .7),
  700: Color.fromRGBO(134, 161, 134, .8),
  800: Color.fromRGBO(134, 161, 134, .9),
  900: Color.fromRGBO(134, 161, 134, 1),
};

AppLocalizations i18n;

class OuistitiApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ouistiti',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: MaterialColor(0xff86A186, primaryColor),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SelectGamePage(),
      supportedLocales: [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      backgroundColor: MaterialColor(0xff366336, boardColor),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SelectGamePage extends StatefulWidget {
  SelectGamePage({Key key}) : super(key: key);

  @override
  _SelectGamePageState createState() => _SelectGamePageState();
}

class _SelectGamePageState extends State<SelectGamePage> {
  double height, width;
  IO.Socket socketIO;
  List<OuistitiGame> listGames;

  @override
  void initState() {
    // Initialising the game list
    listGames = List<OuistitiGame>();

    // Creating the socket
    socketIO = IO.io('https://ec2.tomika.ink/ouistiti', <String, dynamic>{
      'transports': ['websocket'],
      'autoconnect': false
    });

    // Triggers when the websocket connection to the backend has successfully established
    socketIO.on('connect', (_) {
      print("Socket connected");
    });

    // Subscribe to an event to listen to
    socketIO.on('listGames', (games) {
      print("listGames");
      setState(() {
        listGames.clear();
        for (dynamic game in games) {
          listGames.add(OuistitiGame.fromMap(game));
        }
      });
    });

    // Connect to the socket
    socketIO.connect();

    super.initState();
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
              child: ListView.builder(
                itemCount: listGames.length,
                itemBuilder: (BuildContext context, int index) {
                  OuistitiGame game = listGames[index];
                  return Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
                      child: Material(
                          color: MaterialColor(0xff86A186, primaryColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          // margin: const EdgeInsets.only(bottom: 20.0),
                          child: InkWell(
                              onTap: () {
                                /*setState(() {

                          });*/
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
                                            fontSize: 15.0,
                                            color: Colors.white))),
                              ))));
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return CreateGameScreen(context, socketIO);
              },
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
