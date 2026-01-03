import 'package:flutter_bloc/flutter_bloc.dart';
import 'characters_event.dart';
import 'characters_state.dart';
import '../../domain/repositories/characters_repository.dart';

class CharactersBloc
    extends Bloc<CharactersEvent, CharactersState> {
  final CharactersRepository repository;
  final int _page = 1;

  CharactersBloc(this.repository) : super(CharactersInitial()) {
    on<GetCharacters>(_onGetCharacters);
  }

  Future<void> _onGetCharacters(
    GetCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    emit(CharactersLoading());
    try {
      final characters = await repository.getCharacters(_page);
      emit(CharactersLoaded(characters));
    } catch (e) {
      emit(CharactersError(e.toString()));
    }
  }
}
