import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/features/breeds/presentation/pages/widgets/star_rating.dart';

void main() {
  group('StarRating', () {
    testWidgets('should render correct number of filled and outlined stars', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StarRating(value: 3))),
      );

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(2));
    });

    testWidgets('should handle 0 stars', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StarRating(value: 0))),
      );

      expect(find.byIcon(Icons.star_rounded), findsNothing);
      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));
    });

    testWidgets('should handle 5 stars', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StarRating(value: 5))),
      );

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
      expect(find.byIcon(Icons.star_outline_rounded), findsNothing);
    });
  });
}
