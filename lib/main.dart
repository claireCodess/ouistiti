import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ouistiti/widget/screen/CreateGameScreen.dart';
import 'package:ouistiti/widget/screen/InGameScreen.dart';
import 'package:ouistiti/widget/screen/SelectGameScreen.dart';
import 'package:provider/provider.dart';

import 'i18n/AppLocalizations.dart';
import 'model/GamesModel.dart';

void main() {
  runApp(
      Provider<GamesModel>(create: (_) => GamesModel(), child: OuistitiApp()));
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
      initialRoute: SelectGameScreen.pageName,
      routes: <String, WidgetBuilder>{
        SelectGameScreen.pageName: (context) => SelectGameScreen(),
        CreateGameScreen.pageName: (context) => CreateGameScreen(),
        InGameScreen.pageName: (context) => InGameScreen(),
      },
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
