import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ouistiti/socket/Socket.dart';
import 'package:ouistiti/util/error/JoinGameError.dart';
import 'package:provider/provider.dart';

class JoinGameViewModel extends ChangeNotifier {
  Socket _socket;
/*
  StreamController<JoinGameError> _errorMessageController = new StreamController();
  Stream<JoinGameError> get errorMessageToStream => _errorMessageController.stream;
*/
  JoinGameError joinGameError;

  JoinGameViewModel({@required Socket socket}) {
    _socket = socket;
    JoinGameErrorType errorType;
    String errorMessageKey;

    socket.errorMessageToStream.listen((error) {
      switch (error) {
        case "Please enter a nickname":
          {
            errorType = JoinGameErrorType.NICKNAME_ERROR;
            errorMessageKey = "error_no_nickname";
            break;
          }
        case "The chosen nickname is already taken":
          {
            errorType = JoinGameErrorType.NICKNAME_ERROR;
            errorMessageKey = "error_nickname_used";
            break;
          }
        case "Password is incorrect":
          {
            errorType = JoinGameErrorType.PASSWORD_ERROR;
            errorMessageKey = "error_wrong_password";
            break;
          }
        case "The game requested could not be found":
          {
            errorType = JoinGameErrorType.OTHER_ERROR;
            errorMessageKey = "error_game_not_found";
            break;
          }
        case "Please enter a nickname less than 20 characters long":
          {
            errorType = JoinGameErrorType.NICKNAME_ERROR;
            errorMessageKey = "error_nickname_too_long";
            break;
          }
      // The below errors have been treated before even calling joinGame on socket
      // But we'll put them here anyway
        case "No more players can join this game":
          {
            errorType = JoinGameErrorType.OTHER_ERROR;
            errorMessageKey = "error_game_full";
            break;
          }
        case "The game requested is already in progress":
          {
            errorType = JoinGameErrorType.OTHER_ERROR;
            errorMessageKey = "error_game_in_progress";
            break;
          }
        default:
          {
            errorType = JoinGameErrorType.OTHER_ERROR;
            errorMessageKey = "error_generic";
          }
      }
      showJoinGameError(errorMessageKey, errorType);
    });
  }

  // Show an error without making a useless call to the socket
  void showJoinGameError(String errorMessageKey, JoinGameErrorType errorType) {
    joinGameError = JoinGameError(errorType: errorType, errorMessageKey: errorMessageKey);
    notifyListeners();
  }
}