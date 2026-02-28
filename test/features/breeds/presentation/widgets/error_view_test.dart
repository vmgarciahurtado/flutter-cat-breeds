import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/core/constants/strings.dart';
import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/error_view.dart';

void main() {
  group('ErrorView', () {
    testWidgets('should render network failure message and respond to tap', (
      tester,
    ) async {
      var callCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              failure: const Failure.network('No internet connection.'),
              onRetry: () => callCount++,
            ),
          ),
        ),
      );

      expect(find.text('No internet connection.'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(AppStrings.retry), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(callCount, 1);
    });

    testWidgets('should render server failure message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              failure: const Failure.server('Server error.'),
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Server error.'), findsOneWidget);
    });

    testWidgets('should render unknown failure message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              failure: const Failure.unknown('Unknown error.'),
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text(AppStrings.errorOccurred), findsOneWidget);
    });
  });
}
