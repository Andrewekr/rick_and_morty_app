import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/characters/data/datasource/characters_remote_data_source.dart';
import '../features/characters/data/repositories/characters_repository_impl.dart';
import '../features/characters/domain/repositories/characters_repository.dart';
import '../features/characters/presentation/bloc/characters_bloc.dart';

class AppDI {
  static Dio provideDio() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://rickandmortyapi.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  static CharactersRemoteDataSource provideCharactersRemoteDataSource(
    Dio dio,
  ) {
    return CharactersRemoteDataSourceImpl(dio);
  }

  static CharactersRepository provideCharactersRepository(
    CharactersRemoteDataSource remoteDataSource,
  ) {
    return CharactersRepositoryImpl(remoteDataSource);
  }

  static CharactersBloc provideCharactersBloc(
    CharactersRepository repository,
  ) {
    return CharactersBloc(repository);
  }

  /// Все BLoC'и приложения
  static List<BlocProvider> blocProviders() {
    final dio = provideDio();
    final remote = provideCharactersRemoteDataSource(dio);
    final repo = provideCharactersRepository(remote);

    return [
      BlocProvider<CharactersBloc>(
        create: (_) => provideCharactersBloc(repo),
      ),
    ];
  }
}
