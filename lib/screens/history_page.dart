import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/my_app_state_viewmodel.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    if (appState.histories.isEmpty) {
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
              child: Text(
                "You have ${appState.histories.length} history items:",
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  childAspectRatio: 400 / 80,
                ),
                children: [
                  for (var pair in appState.histories)
                    ListTile(
                      leading: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          semanticLabel: 'Delete',
                        ),
                        color: theme.colorScheme.primary,
                        onPressed: () {
                          appState.removeHistory(pair);
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
