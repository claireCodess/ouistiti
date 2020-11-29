import 'dart:async';

import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:ouistiti/dto/OuistitiGameDetails.dart';
import 'package:ouistiti/util/error/JoinGameError.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GamesModel {
  IO.Socket socketIO;

  // Raw data
  List<OuistitiGame> listGames = List<OuistitiGame>();
  OuistitiGameDetails currentGame;

  // Streams and StreamControllers
  StreamController<List<OuistitiGame>> _listGamesController =
      new StreamController();
  Stream<List<OuistitiGame>> get listGamesToStream =>
      _listGamesController.stream;
  StreamController<JoinGameError> _errorMessageController =
      new StreamController.broadcast();
  Stream<JoinGameError> get errorMessageToStream =>
      _errorMessageController.stream;

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

    socketIO.on('joinGameSuccess', (data) {
      print("joinGameSuccess");
      currentGame = OuistitiGameDetails.fromMap(data);
    });

    socketIO.on('joinGameError', (errorMessage) {
      print("joinGameError: $errorMessage");
      JoinGameErrorType errorType;
      switch (errorMessage) {
        case "Please enter a nickname":
          {
            errorType = JoinGameErrorType.NICKNAME_ERROR;
            break;
          }
        case "The chosen nickname is already taken":
          {
            errorType = JoinGameErrorType.NICKNAME_ERROR;
            break;
          }
        case "Password is incorrect":
          {
            errorType = JoinGameErrorType.PASSWORD_ERROR;
            break;
          }
        case "The game requested could not be found":
          {
            errorType = JoinGameErrorType.OTHER_ERROR;
            break;
          }
        // The below errors have been treated before even calling joinGame on socket
        // But we'll put them here anyway
        case "Please enter a nickname less than 20 characters long":
          {
            // Make the errorMessage shorter
            errorMessage = "Nickname too long";
            errorType = JoinGameErrorType.NICKNAME_ERROR;
            break;
          }
        case "No more players can join this game":
          {
            errorType = JoinGameErrorType.OTHER_ERROR;
            break;
          }
        case "The game requested is already in progress":
          {
            errorType = JoinGameErrorType.OTHER_ERROR;
            break;
          }
        default:
          {
            errorType = JoinGameErrorType.OTHER_ERROR;
          }
      }
      _errorMessageController
          .add(JoinGameError(errorType: errorType, errorMessage: errorMessage));
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
  }

  // Show an error without making a useless call to the socket
  void showError(String errorMessage, JoinGameErrorType errorType) {
    _errorMessageController
        .add(JoinGameError(errorType: errorType, errorMessage: errorMessage));
  }
}
