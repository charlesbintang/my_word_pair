import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import '../data/entities/wordpair.dart';
import '../services/wordpair_service.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var isNotSavedLocally = true;

  GlobalKey? historyListKey;

  var favorites = <WordPair>[];

  /// Histories loaded from backend (category = 'history')
  var history = <WordPair>[];

  final WordPairService _wordPairService = WordPairService();

  void changeSaveMethod() {
    isNotSavedLocally = !isNotSavedLocally;

    notifyListeners();
  }

  /// Menghapus item dengan id tertentu melalui API
  Future<void> deleteWordPair(WordPair pair) async {
    try {
      // Cari WordPairEntity berdasarkan firstWord dan secondWord
      final List<WordPairEntity> wordPairs = await _wordPairService
          .findAllWordPair(
            params: '?firstWord=${pair.first}&secondWord=${pair.second}',
          );
      if (wordPairs.isEmpty) {
        debugPrint('WordPair not found in backend: ${pair.asLowerCase}');
        return;
      } // Asumsikan hanya ada satu entri unik
      final String id = wordPairs.first.id;

      await _wordPairService.deleteWordPair(id: id);

      notifyListeners();
    } catch (e) {
      debugPrint('Error delete word pair: $e');
    }
  }

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);

    if (isNotSavedLocally) {
      // Kirim ke backend dengan category "history"
      _wordPairService.createWordPair(pair: current, category: 'history');
    }

    current = WordPair.random();
    notifyListeners();
  }

  /// Memuat favorites dari API berdasarkan category "favorites"
  Future<void> loadFavorites() async {
    try {
      // Memanggil API dengan filter category=favorites
      final List<WordPairEntity> wordPairs = await _wordPairService
          .findAllWordPair(params: '?category=favorites');

      // Konversi WordPairEntity ke WordPair dan filter hanya yang category="favorites"
      final filteredFavorites = wordPairs.map((entity) {
        // Membuat WordPair dari firstWord dan secondWord
        // WordPair memiliki constructor yang menerima dua string
        return WordPair(entity.firstWord, entity.secondWord);
      }).toList();

      favorites = filteredFavorites;
      debugPrint('Loaded ${favorites.length} favorites from API');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      // Tetap biarkan aplikasi berjalan meski error
    }
  }

  /// Memuat histories dari API berdasarkan category "history"
  Future<void> loadHistories() async {
    try {
      final List<WordPairEntity> wordPairs = await _wordPairService
          .findAllWordPair(params: '?category=history');

      final filtered = wordPairs
          .map((entity) => WordPair(entity.firstWord, entity.secondWord))
          .toList();

      history = filtered;
      debugPrint('Loaded ${history.length} histories from API');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading histories: $e');
    }
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    debugPrint('${pair.asLowerCase} removed from favorites');
    notifyListeners();
  }

  void removeHistory(WordPair pair) {
    history.remove(pair);
    deleteWordPair(pair);
    notifyListeners();
  }

  void toggleFavorite({WordPair? pair}) {
    final target = pair ?? current;

    if (favorites.contains(target)) {
      favorites.remove(target);
      debugPrint('${target.asLowerCase} removed from favorites');
    } else {
      favorites.insert(0, target);
      debugPrint('${target.asLowerCase} added to favorites');

      if (isNotSavedLocally) {
        // Kirim ke backend dengan category "favorites"
        _wordPairService.createWordPair(pair: target, category: 'favorites');
      }
    }

    notifyListeners();
  }

  Future<void> updateCategoryWordPairToHistory(WordPair pair) async {
    try {
      // Cari WordPairEntity berdasarkan firstWord dan secondWord
      final List<WordPairEntity> wordPairs = await _wordPairService
          .findAllWordPair(
            params: '?firstWord=${pair.first}&secondWord=${pair.second}',
          );
      if (wordPairs.isEmpty) {
        debugPrint('WordPair not found in backend: ${pair.asLowerCase}');
        return;
      } // Asumsikan hanya ada satu entri unik
      final String id = wordPairs.first.id;

      await _wordPairService.updateWordPair(id: id, category: 'history');

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating word pair: $e');
    }
  }
}
