import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import '../services/wordpair_service.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];
  var isNotSavedLocally = true;

  GlobalKey? historyListKey;

  var favorites = <WordPair>[];

  final WordPairService _wordPairService = WordPairService();

  void changeSaveMethod() {
    isNotSavedLocally = !isNotSavedLocally;

    notifyListeners();
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

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  void toggleFavorite({WordPair? pair}) {
    final target = pair ?? current;

    if (favorites.contains(target)) {
      favorites.remove(target);
      debugPrint('${target.asLowerCase} removed from favorites');
    } else {
      favorites.add(target);
      debugPrint('${target.asLowerCase} added to favorites');

      if (isNotSavedLocally) {
        // Kirim ke backend dengan category "favorites"
        _wordPairService.createWordPair(pair: target, category: 'favorites');
      }
    }

    notifyListeners();
  }
}
