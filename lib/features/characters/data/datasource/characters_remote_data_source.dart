import 'package:dio/dio.dart';
import '../models/character_model.dart';

abstract class CharactersRemoteDataSource {
  Future<List<CharacterModel>> getCharacters(int page);

  /// Получение персонажа по ID (нужно для Favorites)
  Future<CharacterModel> getCharacterById(int id);
}

class CharactersRemoteDataSourceImpl
    implements CharactersRemoteDataSource {
  final Dio dio;

  CharactersRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CharacterModel>> getCharacters(int page) async {
    final response = await dio.get(
      '/character',
      queryParameters: {'page': page},
    );

    final results = response.data['results'] as List;
    return results
        .map((json) => CharacterModel.fromJson(json))
        .toList();
  }

  @override
  Future<CharacterModel> getCharacterById(int id) async {
    final response = await dio.get('/character/$id');
    return CharacterModel.fromJson(response.data);
  }
}
