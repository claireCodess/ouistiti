import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inject/inject.dart';
import 'package:ouistiti/di/get_it/Injection.dart';
import 'package:ouistiti/dto/OuistitiGame.dart';
import 'package:ouistiti/socket/Socket.dart';

part 'list_games_event.dart';
part 'list_games_state.dart';

@provide
class ListGamesBloc extends Bloc<ListGamesEvent, ListGamesState> {
  Socket _socket;
  ListGamesBloc(this._socket) : super(ListGamesInitial()) {
    _socket.listGamesToStream.listen((games) {
      print("listGames event received in stream");
      this.add(GetListGames(games));
    });
  }

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
