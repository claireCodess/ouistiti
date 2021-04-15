import 'package:inject/inject.dart';
import 'package:ouistiti/socket/Socket.dart';
import 'package:ouistiti/widget/screen/SelectGameScreen.dart';

import '../../main.dart';
import 'app_injector.inject.dart' as g;

@Injector()
abstract class AppInjector {
  @provide
  OuistitiApp get app;

  @provide
  Socket get socket;

  @provide
  SelectGameScreen get selectGameScreen;

  static Future<AppInjector> create() {
    return g.AppInjector$Injector.create();
  }
}
