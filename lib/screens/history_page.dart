import 'package:flutter/material.dart';
import 'package:my_word_pair/data/entities/word_pair_entity.dart';
import 'package:provider/provider.dart';

import '../viewmodels/my_app_state_viewmodel.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    if (appState.history.isEmpty) {
      return Center(child: const Text('No history yet.'));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("You have ${appState.history.length} history items:"),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 500,
                  childAspectRatio: 500 / 80,
                ),
                children: [
                  for (var pair in appState.history)
                    ListTile(
                      leading: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          semanticLabel: 'Delete',
                        ),
                        color: theme.colorScheme.primary,
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                            context,
                            appState,
                            pair,
                          );
                        },
                      ),
                      title: Text(
                        "${pair.firstWord.toLowerCase()} ${pair.secondWord.toLowerCase()}",
                        semanticsLabel: "${pair.firstWord} ${pair.secondWord}",
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          appState.favorites.any(
                                (element) => element.clientId == pair.clientId,
                              )
                              ? Icons.favorite
                              : Icons.favorite_border,
                          semanticLabel: 'Like',
                        ),
                        color: theme.colorScheme.primary,
                        onPressed: () {
                          appState.toggleFavorite(pair);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    MyAppState appState,
    WordPairEntity pair,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Item?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Apakah Anda yakin ingin menghapus item ini?'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${pair.firstWord.toLowerCase()} ${pair.secondWord.toLowerCase()}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                appState.removeHistory(pair);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
