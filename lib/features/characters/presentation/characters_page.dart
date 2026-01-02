import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/characters_bloc.dart';
import 'bloc/characters_event.dart';
import 'bloc/characters_state.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          if (state is CharactersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CharactersLoaded) {
            return ListView.builder(
              itemCount: state.characters.length,
              itemBuilder: (context, index) {
                final c = state.characters[index];
                return ListTile(
                  leading: Image.network(c.image),
                  title: Text(c.name),
                  subtitle: Text('${c.status} • ${c.species}'),
                );
              },
            );
          }

          if (state is CharactersError) {
            return Center(child: Text(state.message));
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
