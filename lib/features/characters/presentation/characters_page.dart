import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/features/favorites/data/datasource/repositories/favorites_storage.dart';

import 'bloc/characters_bloc.dart';
import 'bloc/characters_event.dart';
import 'bloc/characters_state.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final FavoritesStorage _favoritesStorage = FavoritesStorage();

  Set<int> _favoriteIds = {};
  bool _favoritesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoritesStorage.getFavorites();
    if (!mounted) return;

    setState(() {
      _favoriteIds = favorites;
      _favoritesLoaded = true;
    });
  }

  Future<void> _toggleFavorite(int id) async {
    final isFavorite = _favoriteIds.contains(id);

    setState(() {
      if (isFavorite) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });

    if (isFavorite) {
      await _favoritesStorage.remove(id);
    } else {
      await _favoritesStorage.add(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
      ),
      body: !_favoritesLoaded
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<CharactersBloc, CharactersState>(
              builder: (context, state) {
                if (state is CharactersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CharactersLoaded) {
                  return ListView.builder(
                    itemCount: state.characters.length,
                    itemBuilder: (context, index) {
                      final character = state.characters[index];
                      final isFavorite =
                          _favoriteIds.contains(character.id);

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
                          icon: Icon(
                            isFavorite
                                ? Icons.star
                                : Icons.star_border,
                            color:
                                isFavorite ? Colors.amber : null,
                          ),
                          onPressed: () =>
                              _toggleFavorite(character.id),
                        ),
                      );
                    },
                  );
                }

                if (state is CharactersError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return const Center(
                  child: Text('Загрузка персонажей...'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CharactersBloc>().add(GetCharacters());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
