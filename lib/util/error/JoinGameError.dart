import 'package:flutter/cupertino.dart';

enum GameConfigErrorType { NICKNAME_ERROR, PASSWORD_ERROR, OTHER_ERROR }

class JoinGameError {
  const JoinGameError(
      {@required this.errorType, @required this.errorMessageKey});

  final GameConfigErrorType errorType;
  final String errorMessageKey;
}
