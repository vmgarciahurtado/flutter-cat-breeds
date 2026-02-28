import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds/core/constants/strings.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breed_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../breeds_test_data.dart';

Future<void> pumpDetailPage(WidgetTester tester, Breed breed) async {
  await tester.pumpWidget(MaterialApp(home: BreedDetailPage(breed: breed)));
}

void main() {
  group('BreedDetailPage', () {
    testWidgets('should render breed name and description', (tester) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        await pumpDetailPage(tester, breedTestData);

        // Then
        expect(find.text(breedTestData.name), findsWidgets);
        expect(find.text(breedTestData.description), findsOneWidget);
      });
    });

    testWidgets('should render general section with origin and lifeSpan', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        await pumpDetailPage(tester, breedTestData);

        // Then
        expect(find.text(AppStrings.sectionGeneral), findsOneWidget);
        expect(find.text(breedTestData.origin), findsWidgets);
        expect(find.text(breedTestData.lifeSpan), findsOneWidget);
      });
    });

    testWidgets('should render back button and pop on tap', (tester) async {
      await mockNetworkImagesFor(() async {
        // Given
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BreedDetailPage(breed: breedTestData),
                    ),
                  ),
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        );

        // When
        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Then
        expect(find.text('Go'), findsOneWidget);
      });
    });

    testWidgets('should render CachedNetworkImage for breed photo', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        await pumpDetailPage(tester, breedTestData);

        // Then
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });
    });

    testWidgets('should render pets icon when breed image fails to load', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given
        await pumpDetailPage(tester, breedTestData);

        final imageFinder = find.byType(CachedNetworkImage).first;
        final CachedNetworkImage cachedImage = tester.widget(imageFinder);

        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: cachedImage.errorWidget?.call(
                tester.element(imageFinder),
                breedTestData.imageId!,
                Exception(),
              ),
            ),
          ),
        );

        // Then
        expect(find.byIcon(Icons.pets), findsOneWidget);
      });
    });

    testWidgets('should render placeholder container while image loads', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given
        await pumpDetailPage(tester, breedTestData);

        final imageFinder = find.byType(CachedNetworkImage).first;
        final CachedNetworkImage cachedImage = tester.widget(imageFinder);

        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: cachedImage.placeholder?.call(
                tester.element(imageFinder),
                breedTestData.imageId!,
              ),
            ),
          ),
        );

        // Then
        expect(find.byType(Container), findsOneWidget);
      });
    });

    testWidgets(
      'should render two CachedNetworkImage when breed has countryCode',
      (tester) async {
        await mockNetworkImagesFor(() async {
          // Given & When
          await pumpDetailPage(tester, breedTestDataWithFlag);

          // Then
          expect(find.byType(CachedNetworkImage), findsNWidgets(2));
        });
      },
    );

    testWidgets('should render SizedBox when flag fails to load', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given
        await pumpDetailPage(tester, breedTestDataWithFlag);

        final flagFinder = find.byType(CachedNetworkImage).last;
        final CachedNetworkImage cachedFlag = tester.widget(flagFinder);

        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: cachedFlag.errorWidget?.call(
                tester.element(flagFinder),
                breedTestDataWithFlag.countryCode!,
                Exception(),
              ),
            ),
          ),
        );

        // Then
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    testWidgets('should render weight section when breed has weight', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        await pumpDetailPage(tester, breedTestDataWithWeight);
        await tester.pumpAndSettle();

        // Then
        expect(find.text(AppStrings.sectionWeight), findsOneWidget);
        expect(find.textContaining('3 - 5'), findsOneWidget);
        expect(find.textContaining('7 - 10'), findsOneWidget);
      });
    });

    testWidgets('should not render weight section when breed has no weight', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        await pumpDetailPage(tester, breedTestData);

        // Then
        expect(find.text(AppStrings.sectionWeight), findsNothing);
      });
    });

    testWidgets('should render temperament when present', (tester) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        await pumpDetailPage(tester, breedTestDataWithTemperament);

        // Then
        expect(
          find.text(breedTestDataWithTemperament.temperament!),
          findsOneWidget,
        );
      });
    });

    testWidgets(
      'should render personality section when breed has rated fields',
      (tester) async {
        await mockNetworkImagesFor(() async {
          // Given & When
          await pumpDetailPage(tester, breedTestDataWithRatings);

          // Then
          expect(find.text(AppStrings.sectionPersonality), findsOneWidget);
          expect(
            find.textContaining('5 ${AppStrings.labelOutOf5}'),
            findsOneWidget,
          );
        });
      },
    );

    testWidgets(
      'should not render personality section when all rated fields are null',
      (tester) async {
        await mockNetworkImagesFor(() async {
          // Given & When
          await pumpDetailPage(tester, breedTestData);

          // Then
          expect(find.text(AppStrings.sectionPersonality), findsNothing);
        });
      },
    );
  });
}
