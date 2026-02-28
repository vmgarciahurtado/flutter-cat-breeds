import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds/core/constants/strings.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:catbreeds/features/breeds/presentation/pages/widgets/breed_card.dart';
import '../../breeds_test_data.dart';

Future<void> pumpBreedCard(
  WidgetTester tester,
  Breed breed, {
  VoidCallback? onTap,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: BreedCard(breed: breed, onTap: onTap ?? () {}),
      ),
    ),
  );
}

void main() {
  group('BreedCard', () {
    testWidgets(
      'should render breed name, origin, intelligence label and StarRating',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await pumpBreedCard(tester, breedTestData);

          expect(find.text(breedTestData.name), findsOneWidget);
          expect(find.text(breedTestData.origin), findsOneWidget);
          expect(find.textContaining(AppStrings.intelligence), findsWidgets);
          expect(find.byIcon(Icons.star_outline_rounded), findsWidgets);
        });
      },
    );

    testWidgets('should call onTap when card is tapped', (tester) async {
      await mockNetworkImagesFor(() async {
        var tapped = false;
        await pumpBreedCard(tester, breedTestData, onTap: () => tapped = true);

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        expect(tapped, isTrue);
      });
    });

    testWidgets(
      'should render one CachedNetworkImage when breed has no countryCode',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await pumpBreedCard(tester, breedTestData);

          expect(find.byType(CachedNetworkImage), findsOneWidget);
        });
      },
    );

    testWidgets(
      'should render two CachedNetworkImage when breed has countryCode',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await pumpBreedCard(tester, breedTestDataWithFlag);

          expect(find.byType(CachedNetworkImage), findsNWidgets(2));
        });
      },
    );

    testWidgets(
      'should render pets icon placeholder when breed has no imageId',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await pumpBreedCard(tester, breedTestDataNoImage);

          expect(find.byType(CachedNetworkImage), findsNothing);
          expect(find.byIcon(Icons.pets), findsOneWidget);
        });
      },
    );

    testWidgets('should render pets icon when breed image fails to load', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpBreedCard(tester, breedTestData);

        final imageFinder = find.byType(CachedNetworkImage).first;
        final CachedNetworkImage cachedImage = tester.widget(imageFinder);

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

        expect(find.byIcon(Icons.pets), findsOneWidget);
      });
    });

    testWidgets(
      'should render hidden SizedBox when country flag fails to load',
      (tester) async {
        await mockNetworkImagesFor(() async {
          await pumpBreedCard(tester, breedTestDataWithFlag);

          final flagFinder = find.byType(CachedNetworkImage).last;
          final CachedNetworkImage cachedFlag = tester.widget(flagFinder);

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

          expect(find.byType(SizedBox), findsWidgets);
        });
      },
    );
  });
}
