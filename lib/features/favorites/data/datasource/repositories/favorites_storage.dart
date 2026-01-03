import 'package:hive_flutter/hive_flutter.dart';

class FavoritesStorage {
  static const _boxName = 'favorites';

  Future<Box<int>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<int>(_boxName);
    }
    return Hive.box<int>(_boxName);
  }

  /// Получить все избранные ID
  Future<Set<int>> getFavorites() async {
    final box = await _openBox();
    return box.values.toSet();
  }

  /// Проверка
  Future<bool> isFavorite(int id) async {
    final box = await _openBox();
    return box.values.contains(id);
  }

  /// Добавить
  Future<void> add(int id) async {
    final box = await _openBox();
    await box.add(id);
  }

  /// Удалить
  Future<void> remove(int id) async {
    final box = await _openBox();
    final key = box.keys.firstWhere(
      (k) => box.get(k) == id,
    );
    await box.delete(key);
  }
}
