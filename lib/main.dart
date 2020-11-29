import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ouistiti/widget/screen/CreateGameScreen.dart';
import 'package:ouistiti/widget/screen/InGameScreen.dart';
import 'package:ouistiti/widget/screen/SelectGameScreen.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Utilisateurs/A670729/Documents/Perso/ouistiti/lib/util/color/MaterialColorGenerator.dart';

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

class Palette {
  static const Color primary = Color(0xFF86A186);
}

class OuistitiApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor primaryColor = generateMaterialColor(Palette.primary);
    return MaterialApp(
      title: 'Ouistiti',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: primaryColor,
        primaryColorLight: primaryColor.shade300,
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
