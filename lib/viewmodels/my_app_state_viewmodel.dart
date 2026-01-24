import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:my_word_pair/data/entities/word_pair_entity.dart';

import '../services/wordpair_service.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var currentWordPairEntity = WordPairEntity(
    id: '',
    clientId: '',
    firstWord: '',
    secondWord: '',
    category: '',
  );
  var isNotSavedLocally = true;

  GlobalKey? historyListKey;

  var favorites = <WordPairEntity>[];

  /// Histories loaded from backend (category = 'history')
  var history = <WordPairEntity>[];

  final WordPairService _wordPairService = WordPairService();

  void changeSaveMethod() {
    isNotSavedLocally = !isNotSavedLocally;

    notifyListeners();
  }

  WordPairEntity createWordPairEntity(WordPair pair, String category) {
    return WordPairEntity(
      id: '',
      clientId:
          '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(100000).toString()}',
      firstWord: pair.first,
      secondWord: pair.second,
      category: category,
    );
  }

  /// Menghapus item dengan id tertentu melalui API
  Future<void> deleteWordPair(WordPairEntity pair) async {
    try {
      // Cari WordPairEntity berdasarkan firstWord dan secondWord
      final WordPairEntity wordPair = await _wordPairService.findOne(pair.id);
      final String id = wordPair.id;

      await _wordPairService.deleteWordPair(id: id);

      notifyListeners();
    } catch (e) {
      debugPrint('Error delete word pair: $e');
    }
  }

  void getNext() async {
    if (isNotSavedLocally) {
      // Kirim ke backend dengan category "history"
      currentWordPairEntity = await _wordPairService.createWordPair(
        pair: currentWordPairEntity,
        category: 'history',
      );
    }

    history.insert(0, currentWordPairEntity);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);

    current = WordPair.random();
    currentWordPairEntity = createWordPairEntity(current, '');
    notifyListeners();
  }

  Future<void> initializeApp() async {
    debugPrint('Initializing app state...');
    await loadFavorites();
    debugPrint('Favorites loaded: ${favorites.length}');
    await loadHistories();
    debugPrint('Histories loaded: ${history.length}');
    debugPrint(
      'currentWordPairEntity before init: ${currentWordPairEntity.toJson()}',
    );
    currentWordPairEntity = createWordPairEntity(current, '');
    await Future.delayed(const Duration(milliseconds: 1000));
    debugPrint('App state initialized.');
    debugPrint(
      'currentWordPairEntity after init: ${currentWordPairEntity.toJson()}',
    );
    notifyListeners();
  }

  /// Memuat favorites dari API berdasarkan category "favorites"
  Future<void> loadFavorites() async {
    try {
      // Memanggil API dengan filter category=favorites
      final List<WordPairEntity> wordPairs = await _wordPairService
          .findAllWordPair(params: '?category=favorites');

      favorites = wordPairs;
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

      history = wordPairs;
      debugPrint('Loaded ${history.length} histories from API');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading histories: $e');
    }
  }

  void removeFavorite(WordPairEntity pair) {
    updateCategoryWordPairToHistory(pair);
    favorites.remove(pair);
    debugPrint('${pair.firstWord} ${pair.secondWord} removed from favorites');
    notifyListeners();
  }

  void removeHistory(WordPairEntity pair) {
    deleteWordPair(pair);
    history.remove(pair);
    notifyListeners();
  }

  void toggleFavorite(WordPairEntity? pair) async {
    var target = pair ?? currentWordPairEntity;
    debugPrint("target toggle favorite: ${target.toJson()}");

    if (favorites.any((element) => element.clientId == target.clientId)) {
      debugPrint("target found in favorites, removing...");
      updateCategoryWordPairToHistory(target);
      debugPrint('Updating category to history for ${target.toJson()}');
      favorites.removeWhere((element) => element.clientId == target.clientId);
      debugPrint('Target removed from favorites list');
      debugPrint(
        '${target.firstWord} ${target.secondWord} removed from favorites',
      );
      debugPrint(favorites.toString());
    } else {
      if (isNotSavedLocally) {
        // Kirim ke backend dengan category "favorites"
        target = await _wordPairService.createWordPair(
          pair: target,
          category: 'favorites',
        );
      }

      if (pair == null) {
        currentWordPairEntity = target;
        debugPrint(
          'currentWordPairEntity updated: ${currentWordPairEntity.toJson()}',
        );
      }

      favorites.insert(0, target);
      debugPrint('${target.firstWord} ${target.secondWord} added to favorites');
    }

    notifyListeners();
  }

  Future<void> updateCategoryWordPairToHistory(WordPairEntity pair) async {
    try {
      // Cari WordPairEntity berdasarkan firstWord dan secondWord
      final WordPairEntity wordPair = await _wordPairService.findOne(pair.id);
      final String id = wordPair.id;

      await _wordPairService.updateWordPair(id: id, category: 'history');
      debugPrint('Updated category to history for word pair: ${pair.toJson()}');

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating word pair: $e');
    }
  }

  WordPairEntity updateWordPairEntity(WordPairEntity pair, String category) {
    return WordPairEntity(
      id: pair.id,
      clientId: pair.clientId,
      firstWord: pair.firstWord,
      secondWord: pair.secondWord,
      category: category,
    );
  }
}
