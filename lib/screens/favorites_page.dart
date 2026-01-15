import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/app_viewmodel.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    if (appState.favorites.isEmpty) {
      return Center(child: const Text('No favorites yet.'));
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
              child: Text("You have ${appState.favorites.length} favorites:"),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  childAspectRatio: 400 / 80,
                ),
                children: [
                  for (var pair in appState.favorites)
                    ListTile(
                      leading: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          semanticLabel: 'Delete',
                        ),
                        color: theme.colorScheme.primary,
                        onPressed: () {
                          appState.removeFavorite(pair);
                        },
                      ),
                      title: Text(
                        "${pair.first.toLowerCase()} ${pair.second.toLowerCase()}",
                        semanticsLabel: "${pair.first} ${pair.second}",
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
}
