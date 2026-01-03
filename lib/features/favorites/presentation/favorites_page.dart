import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/features/favorites/data/datasource/repositories/favorites_storage.dart';

import '../../../di/di.dart';
import '../../characters/data/models/character_model.dart';
import '../../characters/data/datasource/characters_remote_data_source.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesStorage _favoritesStorage = FavoritesStorage();

  late final CharactersRemoteDataSource _remoteDataSource;

  List<CharacterModel> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    final dio = AppDI.provideDio();
    _remoteDataSource =
        CharactersRemoteDataSourceImpl(dio);

    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoriteIds = await _favoritesStorage.getFavorites();

    final List<CharacterModel> characters = [];

    for (final id in favoriteIds) {
      try {
        final response = await _remoteDataSource.getCharacterById(id);
        characters.add(response);
      } catch (_) {
        // если персонаж не загрузился — пропускаем
      }
    }

    if (!mounted) return;

    setState(() {
      _favorites = characters;
      _loading = false;
    });
  }

  Future<void> _removeFromFavorites(int id) async {
    await _favoritesStorage.remove(id);

    setState(() {
      _favorites.removeWhere((c) => c.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(
                  child: Text('Нет избранных персонажей'),
                )
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final character = _favorites[index];

                    return ListTile(
                      leading: Image.network(
                        character.image,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                      title: Text(character.name),
                      subtitle: Text(
                        '${character.status} • ${character.species}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onPressed: () =>
                            _removeFromFavorites(character.id),
                      ),
                    );
                  },
                ),
    );
  }
}
