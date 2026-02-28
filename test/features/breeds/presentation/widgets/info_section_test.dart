import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catbreeds/features/breeds/presentation/pages/widgets/info_section.dart';

void main() {
  group('InfoSection', () {
    testWidgets('should render title and items successfully', (tester) async {
      const items = [
        InfoItem('Label 1', 'Value 1'),
        InfoItem('Label 2', 'Value 2'),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoSection(title: 'Test Section', items: items),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
      expect(find.text('Label 1'), findsOneWidget);
      expect(find.text('Value 1'), findsOneWidget);
      expect(find.text('Label 2'), findsOneWidget);
      expect(find.text('Value 2'), findsOneWidget);
    });

    testWidgets('should not render anything if valid items list is empty', (
      tester,
    ) async {
      const items = [InfoItem('Label 1', ''), InfoItem('Label 2', '')];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoSection(title: 'Test Section', items: items),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
      expect(find.text('Test Section'), findsNothing);
      expect(find.text('Label 1'), findsNothing);
    });

    testWidgets('should filter out items with empty values', (tester) async {
      const items = [InfoItem('Label 1', 'Value 1'), InfoItem('Label 2', '')];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoSection(title: 'Test Section', items: items),
          ),
        ),
      );

      expect(find.text('Label 1'), findsOneWidget);
      expect(find.text('Value 1'), findsOneWidget);
      expect(find.text('Label 2'), findsNothing);
      expect(find.text('Test Section'), findsOneWidget);
    });
  });
}
