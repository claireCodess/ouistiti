import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:ouistiti/di/Injection.dart';
import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:ouistiti/dto/OuistitiGameDetails.dart';
import 'package:ouistiti/socket/Socket.dart';
import 'package:ouistiti/util/error/JoinGameError.dart';
import 'package:stacked/stacked.dart';

const String _ListGamesStreamKey = 'listgames-stream';
const String _ChosenGameStreamKey = 'chosengame-stream';
const String _JoinGameErrorStreamKey = 'joingameerror-stream';

@injectable
class JoinGameViewModel extends MultipleStreamViewModel {
  Socket _socket;

  List<OuistitiGame> listGames;
  OuistitiGameDetails chosenGame;
  JoinGameError joinGameError;

  @override
  Map<String, StreamData> get streamsMap => {
        _ListGamesStreamKey: StreamData<List<OuistitiGame>>(
            _socket.listGamesToStream, transformData: (games) {
          print("listGames event received in stream");
          listGames = games;
          return listGames;
        }),
        _ChosenGameStreamKey: StreamData<OuistitiGameDetails>(
            _socket.chosenGameToStream, transformData: (game) {
          print("chosenGame event received in stream");
          chosenGame = game;
          return chosenGame;
        }),
        _JoinGameErrorStreamKey: StreamData<String>(
            _socket.errorMessageToStream, transformData: (error) {
          JoinGameErrorType errorType;
          String errorMessageKey;

          print("errorMessage event received in stream");
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
          return showJoinGameError(errorMessageKey, errorType);
        })
      };

  JoinGameViewModel() {
    _socket = getIt<Socket>();
    print("In JoinGameViewModel constructor, hash code:");
    print(this.hashCode);
    print("Hash code of socket in JoinGameViewModel:");
    print(this._socket.hashCode);
  }

  @override
  void dispose() {
    super.dispose();
    print("JoinGameViewModel on dispose, hash code:");
    print(this.hashCode);
  }

  StreamSubscription<List<OuistitiGame>> listenToGamesList() {
    print("Listening to listGames event in stream...");

    return _socket.listGamesToStream.listen((games) {
      print("listGames event received in stream");
      listGames = games;
      notifyListeners();
    });
  }

  StreamSubscription<OuistitiGameDetails> listenToChosenGame() {
    print("Listening to chosenGame event in stream...");

    return _socket.chosenGameToStream.listen((game) {
      print("chosenGame event received in stream");
      chosenGame = game;
      notifyListeners();
    });
  }

  StreamSubscription<String> listenToErrorMessage() {
    print("Listening to errorMessage event in stream...");

    JoinGameErrorType errorType;
    String errorMessageKey;

    return _socket.errorMessageToStream.listen((error) {
      print("errorMessage event received in stream");
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
  JoinGameError showJoinGameError(
      String errorMessageKey, JoinGameErrorType errorType) {
    joinGameError =
        JoinGameError(errorType: errorType, errorMessageKey: errorMessageKey);
    notifyListeners();
    return joinGameError;
  }
}
