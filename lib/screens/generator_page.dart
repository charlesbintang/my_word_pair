import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/app_viewmodel.dart';
import '../widgets/big_card.dart';
import '../widgets/history_list_view.dart';

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData favoriteIcon;
    if (appState.favorites.contains(pair)) {
      favoriteIcon = Icons.favorite;
    } else {
      favoriteIcon = Icons.favorite_border;
    }

    IconData localIcon;
    if (appState.isNotSavedLocally) {
      localIcon = Icons.wifi;
    } else {
      localIcon = Icons.wifi_off;
    }

    String localText;
    if (appState.isNotSavedLocally) {
      localText = "Saved to Cloud Storage";
    } else {
      localText = "Saved to Local Storage";
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                HistoryListView(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          appState.changeSaveMethod();

                          debugPrint(appState.isNotSavedLocally.toString());
                        },
                        icon: Icon(localIcon),
                        label: Text(localText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair: null);
                },
                icon: Icon(favoriteIcon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
