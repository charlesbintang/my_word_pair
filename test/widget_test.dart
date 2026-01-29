// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_word_pair/main.dart';
import 'package:my_word_pair/widgets/big_card.dart';

void main() {
  testWidgets('App starts and displays word pair generator', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the app starts with GeneratorPage (Home tab)
    // Home icon should be in navigation
    expect(find.byIcon(Icons.home), findsOneWidget);
    // Favorite icon should be in navigation (not in Like button initially)
    expect(find.byIcon(Icons.favorite), findsAtLeastNWidgets(1));

    // Verify that Next button exists
    expect(find.text('Next'), findsOneWidget);

    // Verify that Like button exists
    expect(find.text('Like'), findsOneWidget);

    // Verify that BigCard (word pair display) exists
    expect(find.byType(BigCard), findsOneWidget);
  });

  testWidgets('Next button generates new word pair', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Get the initial word pair text
    final initialWordPair = find.byType(BigCard);
    expect(initialWordPair, findsOneWidget);

    final initialText = tester
        .widget<Text>(
          find
              .descendant(of: initialWordPair, matching: find.byType(Text))
              .first,
        )
        .data;

    // Verify the initialText
    expect(initialText, isNotNull);

    // Tap the Next button
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Verify that a new word pair is displayed
    final newText = tester
        .widget<Text>(
          find
              .descendant(of: initialWordPair, matching: find.byType(Text))
              .first,
        )
        .data;

    // The text should have changed (new word pair generated)
    expect(newText, isNot(initialText));
  });

  testWidgets('Like button toggles favorite', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find the Like text - we'll tap this directly
    final likeText = find.text('Like');
    expect(likeText, findsOneWidget);

    // Initially, favorite_border icon should be present (in the button)
    // Note: navigation bar has filled favorite icon, button has favorite_border
    final initialFavoriteBorders = find.byIcon(Icons.favorite_border);
    expect(initialFavoriteBorders, findsOneWidget);

    // Count initial favorite icons (should be at least 1 from navigation)
    final initialFavoriteCount = find.byIcon(Icons.favorite).evaluate().length;
    expect(initialFavoriteCount, greaterThanOrEqualTo(1));

    // Tap the Like button by tapping the text
    await tester.tap(likeText);
    await tester.pumpAndSettle();

    // After tapping, favorite_border should be gone and favorite should appear
    // The button icon should have changed from favorite_border to favorite
    final favoriteBordersAfterTap = find.byIcon(Icons.favorite_border);
    expect(favoriteBordersAfterTap, findsNothing);

    // Should have more favorite icons now (navigation + button)
    final favoriteCountAfterTap = find.byIcon(Icons.favorite).evaluate().length;
    expect(favoriteCountAfterTap, greaterThan(initialFavoriteCount));

    // Tap again to untoggle
    await tester.tap(likeText);
    await tester.pumpAndSettle();

    // Should be back to favorite_border in button
    final favoriteBordersAfterUntoggle = find.byIcon(Icons.favorite_border);
    expect(favoriteBordersAfterUntoggle, findsOneWidget);

    // Favorite icon count should be back to initial (only navigation)
    final favoriteCountAfterUntoggle = find
        .byIcon(Icons.favorite)
        .evaluate()
        .length;
    expect(favoriteCountAfterUntoggle, equals(initialFavoriteCount));
  });

  testWidgets('Navigation to Favorites page works', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find navigation bar or rail
    final navBar = find.byType(BottomNavigationBar);
    final navRail = find.byType(NavigationRail);

    if (navBar.evaluate().isNotEmpty) {
      // Mobile layout - tap second item in BottomNavigationBar (index 1)
      // Find the favorite icon within the BottomNavigationBar
      final favoriteInNav = find.descendant(
        of: navBar,
        matching: find.byIcon(Icons.favorite),
      );
      expect(favoriteInNav, findsOneWidget);
      await tester.tap(favoriteInNav);
    } else if (navRail.evaluate().isNotEmpty) {
      // Desktop layout - tap second destination in NavigationRail
      final favoriteInNav = find.descendant(
        of: navRail,
        matching: find.byIcon(Icons.favorite),
      );
      expect(favoriteInNav, findsOneWidget);
      await tester.tap(favoriteInNav);
    } else {
      // Fallback: try to find by text "Favorites"
      final favoritesText = find.text('Favorites');
      if (favoritesText.evaluate().isNotEmpty) {
        await tester.tap(favoritesText);
      } else {
        // Last resort: tap any favorite icon that's not in a button
        final allFavorites = find.byIcon(Icons.favorite);
        if (allFavorites.evaluate().isNotEmpty) {
          await tester.tap(allFavorites.last);
        }
      }
    }

    await tester.pumpAndSettle();

    // Should show "No favorites yet" message initially
    expect(find.text('No favorites yet.'), findsOneWidget);
  });

  testWidgets('Navigation to Histories page works', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find navigation bar or rail
    final navBar = find.byType(BottomNavigationBar);
    final navRail = find.byType(NavigationRail);

    if (navBar.evaluate().isNotEmpty) {
      // Mobile layout - tap third item in BottomNavigationBar (index 2)
      // Find the history icon within the BottomNavigationBar
      final historyInNav = find.descendant(
        of: navBar,
        matching: find.byIcon(Icons.history),
      );
      expect(historyInNav, findsOneWidget);
      await tester.tap(historyInNav);
    } else if (navRail.evaluate().isNotEmpty) {
      // Desktop layout - tap third destination in NavigationRail
      final historyInNav = find.descendant(
        of: navRail,
        matching: find.byIcon(Icons.history),
      );
      expect(historyInNav, findsOneWidget);
      await tester.tap(historyInNav);
    } else {
      // Fallback: try to find by text "Histories"
      final historiesText = find.text('Histories');
      if (historiesText.evaluate().isNotEmpty) {
        await tester.tap(historiesText);
      } else {
        // Last resort: tap any history icon
        final allHistory = find.byIcon(Icons.history);
        if (allHistory.evaluate().isNotEmpty) {
          await tester.tap(allHistory.first);
        }
      }
    }

    await tester.pumpAndSettle();

    // Should show "No history yet" message initially
    expect(find.text('No history yet.'), findsOneWidget);
  });
}
