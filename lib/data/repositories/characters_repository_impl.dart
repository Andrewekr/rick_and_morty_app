import '../../domain/entities/character.dart';
import '../../domain/repositories/characters_repository.dart';
import '../datasource/characters_remote_data_source.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource remoteDataSource;

  CharactersRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Character>> getCharacters(int page) {
    return remoteDataSource.getCharacters(page);
  }
}
