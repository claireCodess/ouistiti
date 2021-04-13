import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ouistiti/di/Injection.dart';
import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:ouistiti/socket/Socket.dart';

part 'list_games_event.dart';
part 'list_games_state.dart';

class ListGamesBloc extends Bloc<ListGamesEvent, ListGamesState> {
  ListGamesBloc() : super(ListGamesInitial());

  @override
  Stream<ListGamesState> mapEventToState(ListGamesEvent event) async* {
    if (event is InitSocketConnection) {
      yield ListGamesLoading();
      getIt<Socket>().initSocketAndEstablishConnection();
    } else if (event is GetListGames) {
      yield ListGamesSuccess(event.listGames);
    }
  }
}
