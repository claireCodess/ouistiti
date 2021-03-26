// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../socket/Socket.dart';
import '../viewmodel/InGameViewModel.dart';
import '../viewmodel/JoinGameViewModel.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.factory<JoinGameViewModel>(() => JoinGameViewModel());
  gh.factory<InGameViewModel>(() => InGameViewModel());
  gh.lazySingleton<Socket>(() => Socket());
  return get;
}
