import 'dart:async';

import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:ouistiti/dto/OuistitiGameDetails.dart';
import 'package:ouistiti/dto/OuistitiGetNickname.dart';
import 'package:ouistiti/util/error/JoinGameError.dart';
import 'package:ouistiti/util/error/NicknameError.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Socket {
  IO.Socket socketIO;

  // Raw data
  List<OuistitiGame> listGames = List<OuistitiGame>();
  OuistitiGameDetails currentGame;
  OuistitiGetNickname nickname;

  // Streams and StreamControllers
  StreamController<List<OuistitiGame>> _listGamesController =
      new StreamController();
  Stream<List<OuistitiGame>> get listGamesToStream =>
      _listGamesController.stream;

  StreamController<String> _errorMessageController =
      new StreamController.broadcast();
  Stream<String> get errorMessageToStream =>
      _errorMessageController.stream;

  StreamController<OuistitiGameDetails> _currentGameController =
      new StreamController.broadcast();
  Stream<OuistitiGameDetails> get currentGameToStream =>
      _currentGameController.stream;

  StreamController<String> _nicknameController =
      new StreamController.broadcast();
  Stream<String> get nicknameToStream => _nicknameController.stream;

  StreamController<NicknameError> _nicknameErrorMsgController =
      new StreamController.broadcast();
  Stream<NicknameError> get nicknameErrorMsgToStream =>
      _nicknameErrorMsgController.stream;

  void initSocketAndEstablishConnection() async {
    print("Begin initSocketAndEstablishConnection");

    // Initialising the list of games
    listGames = List<OuistitiGame>();

    // Creating the socket
    socketIO = IO.io('https://ec2.tomika.ink/cards', <String, dynamic>{
      'transports': ['websocket'],
      'autoconnect': false
    });

    // Triggers when the websocket connection to the backend has been successfully established
    socketIO.on('connect', (_) {
      print("Socket connected");
    });

    socketIO.on('disconnect', (_) {
      print("Socket disconnected");
    });

    socketIO.on('joinGame', (data) {
      print("joinGameSuccess");
      currentGame = OuistitiGameDetails.fromMap(data);
      print("Current game = $currentGame");
      _currentGameController.add(currentGame);
    });

    socketIO.on('joinGameError', (error) {
      print("joinGameError event received: $error");
      _errorMessageController.add(error);
    });

    socketIO.on('setNickname', (data) {
      print("setNickname event received");
      nickname = OuistitiGetNickname.fromMap(data);
      print(
          "Nickname for player with ID ${nickname.id} changed from ${nickname.oldNickname} to ${nickname.newNickname}");
      _nicknameController.add(nickname.newNickname);
    });

    socketIO.on('nicknameError', (errorMessage) {
      print("nicknameError: $errorMessage");
      switch (errorMessage) {
        case "The chosen nickname is already taken":
          {
            errorMessage = "error_nickname_used";
            break;
          }
        case "Please enter a nickname less than 20 characters long":
          {
            errorMessage = "error_nickname_too_long";
            break;
          }
        default:
          {
            errorMessage = "error_generic";
          }
      }
      _nicknameErrorMsgController
          .add(NicknameError(errorMessageKey: errorMessage));
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
      _listGamesController.add(listGames);
    });

    // Connect to the socket
    socketIO.connect();
    print("End initSocketAndEstablishConnection");
  }

  // Show an error without making a useless call to the socket
  void showNicknameError(String errorMessageKey) {
    _nicknameErrorMsgController
        .add(NicknameError(errorMessageKey: errorMessageKey));
  }
}
