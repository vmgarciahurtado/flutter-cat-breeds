import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:catbreeds/core/constants/strings.dart';
import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/di/breeds_providers.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/domain/usecases/get_breeds_usecase.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breeds_page.dart';
import 'package:catbreeds/features/breeds/presentation/providers/breeds_provider.dart';

import '../../breeds_test_data.dart';

class MockGetBreedsUseCase extends Mock implements GetBreedsUseCase {}

String? navigatedRoute;

GoRouter makeRouter() {
  navigatedRoute = null;
  return GoRouter(
    routes: [
      GoRoute(path: '/breeds', builder: (_, _) => const BreedsPage()),
      GoRoute(
        path: '/breeds/:id',
        builder: (context, state) {
          navigatedRoute = state.uri.toString();
          return const SizedBox();
        },
      ),
    ],
    initialLocation: '/breeds',
  );
}

Future<void> pumpBreedsPage(
  WidgetTester tester,
  MockGetBreedsUseCase mockUseCase,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [getBreedsUseCaseProvider.overrideWithValue(mockUseCase)],
      child: MaterialApp.router(routerConfig: makeRouter()),
    ),
  );
}

void main() {
  late MockGetBreedsUseCase mockUseCase;

  setUp(() => mockUseCase = MockGetBreedsUseCase());

  group('BreedsPage', () {
    testWidgets('should show CircularProgressIndicator while loading', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given
        final completer = Completer<Either<Failure, List<Breed>>>();
        when(() => mockUseCase.call()).thenAnswer((_) => completer.future);

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pump();

        // Then
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        completer.complete(const Right([breedTestData]));
        await tester.pumpAndSettle();
      });
    });

    testWidgets('should show breed cards when data loads successfully', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pumpAndSettle();

        // Then
        expect(find.text(breedTestData.name), findsOneWidget);
        expect(find.text(breedTestData.origin), findsOneWidget);
      });
    });

    testWidgets('should show ErrorView when provider emits a failure', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Left(Failure.network('No internet.')));

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pumpAndSettle();

        // Then
        expect(find.text('No internet.'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
    });

    testWidgets('should show noBreedsFound message when list is empty', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given & When
        when(() => mockUseCase.call()).thenAnswer((_) async => const Right([]));

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pumpAndSettle();

        // Then
        expect(find.text(AppStrings.noBreedsFound), findsOneWidget);
      });
    });

    testWidgets('should filter breeds when searching', (tester) async {
      await mockNetworkImagesFor(() async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pumpAndSettle();

        // When
        await tester.enterText(find.byType(SearchBar), 'abys');
        await tester.pump();

        // Then
        expect(find.text(breedTestData.name), findsOneWidget);
      });
    });

    testWidgets('should show noBreedsFound when search has no matches', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pumpAndSettle();

        // When
        await tester.enterText(find.byType(SearchBar), 'xyz');
        await tester.pump();

        // Then
        expect(find.text(AppStrings.noBreedsFound), findsOneWidget);
      });
    });

    testWidgets('should navigate to breed detail when card is tapped', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text(breedTestData.name));
        await tester.pumpAndSettle();

        // Then
        expect(navigatedRoute, '/breeds/${breedTestData.id}');
      });
    });

    testWidgets('should reload breeds on pull-to-refresh', (tester) async {
      await mockNetworkImagesFor(() async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pumpAndSettle();

        // When
        await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
        await tester.pumpAndSettle();

        // Then
        expect(find.text(breedTestData.name), findsOneWidget);
      });
    });

    testWidgets('should call refresh when tapping retry button', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Left(Failure.network('No internet.')));

        await pumpBreedsPage(tester, mockUseCase);
        await tester.pumpAndSettle();
        expect(find.byType(FilledButton), findsOneWidget);

        // When
        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();

        // Then
        expect(find.text('No internet.'), findsOneWidget);
      });
    });

    testWidgets('should retry and show data when tapping retry after error', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Left(Failure.network('No internet.')));

        final container = ProviderContainer(
          overrides: [getBreedsUseCaseProvider.overrideWithValue(mockUseCase)],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(routerConfig: makeRouter()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('No internet.'), findsOneWidget);

        // When
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));
        await container.read(breedsProvider.notifier).refresh();
        await tester.pumpAndSettle();

        // Then
        expect(find.text(breedTestData.name), findsOneWidget);
      });
    });
  });
}
