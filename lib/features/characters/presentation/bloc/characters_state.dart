import '../../domain/entities/character.dart';

abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;

  CharactersLoaded(this.characters);
}

class CharactersError extends CharactersState {
  final String message;

  CharactersError(this.message);
}
