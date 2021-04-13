part of 'list_games_bloc.dart';

abstract class ListGamesEvent extends Equatable {
  const ListGamesEvent();
}

class InitSocketConnection extends ListGamesEvent {
  InitSocketConnection();

  @override
  List<Object> get props => [];
}

class GetListGames extends ListGamesEvent {
  final List<OuistitiGame> listGames;

  GetListGames(this.listGames);

  @override
  List<Object> get props => [listGames];
}
