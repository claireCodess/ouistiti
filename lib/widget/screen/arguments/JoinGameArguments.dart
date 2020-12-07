import 'package:ouistiti/dto/OuistitiGameDetails.dart';

class JoinGameArguments {
  const JoinGameArguments(this.gameDetails, this.nickname);

  final OuistitiGameDetails gameDetails;
  final String nickname;
}
