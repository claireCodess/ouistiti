part of 'list_games_bloc.dart';

abstract class ListGamesState extends Equatable {
  const ListGamesState() : super();

  @override
  List<Object> get props => [];
}

class ListGamesInitial extends ListGamesState {}

class ListGamesLoading extends ListGamesState {}

class ListGamesSuccess extends ListGamesState {
  final List<OuistitiGame> listGames;

  ListGamesSuccess(this.listGames) : super();

  @override
  List<Object> get props => [listGames];
}
