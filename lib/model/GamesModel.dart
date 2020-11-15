import 'dart:async';

import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GamesModel {
  IO.Socket socketIO;
  List<OuistitiGame> listGames = List<OuistitiGame>();
  StreamController<List<OuistitiGame>> _controller = new StreamController();
  Stream<List<OuistitiGame>> get listGamesToStream => _controller.stream;

  void initSocketAndEstablishConnection() async {
    // Initialising the list of games
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

    socketIO.on('disconnect', (_) {
      print("Socket disconnected");
    });

    // Subscribe to an event to listen to
    socketIO.on('listGames', (games) {
      print("listGames");
      print("There are currently ${games.length} games");
      // It's important here that listGames gets replaced by a new instance.
      // If we just call clear() on it, the controller will get the impression
      // that the data hasn't changed, and thus will not send the event.
      listGames = List<OuistitiGame>();
      for (dynamic game in games) {
        listGames.add(OuistitiGame.fromMap(game));
      }
      print("Add to controller the new list of games");
      _controller.add(listGames);
    });

    // Connect to the socket
    socketIO.connect();
  }
}
