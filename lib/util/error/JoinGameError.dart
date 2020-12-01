import 'package:flutter/cupertino.dart';

enum JoinGameErrorType { NICKNAME_ERROR, PASSWORD_ERROR, OTHER_ERROR }

class JoinGameError {
  const JoinGameError(
      {@required this.errorType, @required this.errorMessageKey});

  final JoinGameErrorType errorType;
  final String errorMessageKey;
}
