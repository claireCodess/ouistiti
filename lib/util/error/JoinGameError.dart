import 'package:flutter/cupertino.dart';

enum JoinGameErrorType { NICKNAME_ERROR, PASSWORD_ERROR, OTHER_ERROR }

class JoinGameError {
  const JoinGameError({@required this.errorType, @required this.errorMessage});

  final JoinGameErrorType errorType;
  final String errorMessage;
}
