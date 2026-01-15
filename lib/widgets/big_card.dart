import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final WordPair pair;

  const BigCard({super.key, required this.pair});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      elevation: 8,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window
          // is too narrow.
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  pair.first.toLowerCase(),
                  style: style.copyWith(fontWeight: FontWeight.w200),
                  semanticsLabel: pair.first,
                ),
                SizedBox(width: 10),
                Text(
                  pair.second.toLowerCase(),
                  style: style.copyWith(fontWeight: FontWeight.bold),
                  semanticsLabel: pair.second,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
