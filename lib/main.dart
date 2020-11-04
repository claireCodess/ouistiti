import 'package:flutter/material.dart';

void main() {
  runApp(OuistitiApp());
}

Map<int, Color> boardColor =
{
  50:Color.fromRGBO(54,99,54, .1),
  100:Color.fromRGBO(54,99,54, .2),
  200:Color.fromRGBO(54,99,54, .3),
  300:Color.fromRGBO(54,99,54, .4),
  400:Color.fromRGBO(54,99,54, .5),
  500:Color.fromRGBO(54,99,54, .6),
  600:Color.fromRGBO(54,99,54, .7),
  700:Color.fromRGBO(54,99,54, .8),
  800:Color.fromRGBO(54,99,54, .9),
  900:Color.fromRGBO(54,99,54, 1),
};

Map<int, Color> primaryColor =
{
  50:Color.fromRGBO(134,161,134, .1),
  100:Color.fromRGBO(134,161,134, .2),
  200:Color.fromRGBO(134,161,134, .3),
  300:Color.fromRGBO(134,161,134, .4),
  400:Color.fromRGBO(134,161,134, .5),
  500:Color.fromRGBO(134,161,134, .6),
  600:Color.fromRGBO(134,161,134, .7),
  700:Color.fromRGBO(134,161,134, .8),
  800:Color.fromRGBO(134,161,134, .9),
  900:Color.fromRGBO(134,161,134, 1),
};

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
      home: SelectGamePage(title: 'Ouistiti'),
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
          children: <Widget>[
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



class SelectGamePage extends StatefulWidget {
  SelectGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectGamePageState createState() => _SelectGamePageState();
}

class _SelectGamePageState extends State<SelectGamePage> {
  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8)),
            Text("Select game", style: Theme.of(context).textTheme.headline5),
            Padding(padding: EdgeInsets.only(bottom: 8)),
            Container(
              height: height * 0.7,
              width: width,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  int gameIndex = index + 1;
                  return Container(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      onPressed: () {  },
                      child: Container(
                        padding: const EdgeInsets.only(left: 60.0, right: 60.0, top: 20.0, bottom: 20.0),
                        margin: const EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          color: MaterialColor(0xff86A186, primaryColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          "Game $gameIndex",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      )
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
