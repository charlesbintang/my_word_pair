import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:my_word_pair/data/entities/word_pair_entity.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var currentWordPairEntity = WordPairEntity(
    id: '',
    clientId: '',
    firstWord: '',
    secondWord: '',
    category: '',
  );

  GlobalKey? historyListKey;

  var favorites = <WordPairEntity>[];

  /// Histories loaded from backend (category = 'history')
  var history = <WordPairEntity>[];

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

  void getNext() async {
    history.insert(0, currentWordPairEntity);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);

    current = WordPair.random();
    currentWordPairEntity = createWordPairEntity(current, '');
    notifyListeners();
  }

  Future<void> initializeApp() async {
    // debugPrint(
    //   'currentWordPairEntity before init: ${currentWordPairEntity.toJson()}',
    // );
    currentWordPairEntity = createWordPairEntity(current, '');
    // Removed artificial delay to avoid leaving a pending Timer
    // when running widget tests (which fail if timers remain).
    // debugPrint('App state initialized.');
    // debugPrint(
    //   'currentWordPairEntity after init: ${currentWordPairEntity.toJson()}',
    // );
    notifyListeners();
  }

  void removeFavorite(WordPairEntity pair) {
    favorites.remove(pair);
    // debugPrint('${pair.firstWord} ${pair.secondWord} removed from favorites');
    notifyListeners();
  }

  void removeHistory(WordPairEntity pair) {
    // debugPrint('Removing history: ${pair.toJson()}');
    history.remove(pair);
    notifyListeners();
  }

  void toggleFavorite(WordPairEntity? pair) async {
    var target = pair ?? currentWordPairEntity;
    // debugPrint("target toggle favorite: ${target.toJson()}");

    if (favorites.any((element) => element.clientId == target.clientId)) {
      // debugPrint("target found in favorites, removing...");
      // debugPrint('Updating category to history for ${target.toJson()}');
      favorites.removeWhere((element) => element.clientId == target.clientId);
      // debugPrint('Target removed from favorites list');
      // debugPrint(
      //   '${target.firstWord} ${target.secondWord} removed from favorites',
      // );
      // debugPrint(favorites.toString());
    } else {
      if (pair == null) {
        currentWordPairEntity = target;
        // debugPrint(
        //   'currentWordPairEntity updated: ${currentWordPairEntity.toJson()}',
        // );
      }

      favorites.insert(0, target);
      // debugPrint('${target.firstWord} ${target.secondWord} added to favorites');
    }

    notifyListeners();
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
