import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/di/breeds_providers.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/domain/usecases/get_breeds_usecase.dart';
import 'package:catbreeds/features/breeds/presentation/providers/breeds_provider.dart';

import '../../breeds_test_data.dart';

class MockGetBreedsUseCase extends Mock implements GetBreedsUseCase {}

ProviderContainer makeContainer(MockGetBreedsUseCase mock) {
  final container = ProviderContainer(
    overrides: [getBreedsUseCaseProvider.overrideWithValue(mock)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late MockGetBreedsUseCase mockUseCase;

  setUp(() => mockUseCase = MockGetBreedsUseCase());

  group('BreedsProvider', () {
    group('build', () {
      test('should emit AsyncData with breeds list on success', () async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        final container = makeContainer(mockUseCase);

        // When
        final result = await container.read(breedsProvider.future);

        // Then
        expect(result, [breedTestData]);
        verify(() => mockUseCase.call()).called(1);
      });

      test('should emit AsyncError when use case returns a failure', () async {
        // Given
        const failure = Failure.network('No internet.');
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Left(failure));

        final container = makeContainer(mockUseCase);

        // When
        container.read(breedsProvider.future).ignore();
        await Future.microtask(() {});
        final state = container.read(breedsProvider);

        // Then
        expect(state.hasError, isTrue);
        expect(state.error, isA<NetworkFailure>());
      });

      test('should store breeds internally for later search/refresh', () async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        final container = makeContainer(mockUseCase);
        await container.read(breedsProvider.future);

        // When
        container.read(breedsProvider.notifier).search('');

        // Then
        expect(container.read(breedsProvider).value, [breedTestData]);
      });
    });

    group('refresh', () {
      test('should reload breeds and emit AsyncData on success', () async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        final container = makeContainer(mockUseCase);
        await container.read(breedsProvider.future);

        // When
        await container.read(breedsProvider.notifier).refresh();

        // Then
        expect(container.read(breedsProvider).value, [breedTestData]);
        verify(() => mockUseCase.call()).called(2);
      });

      test('should emit AsyncError on failure during refresh', () async {
        // Given
        const failure = Failure.server('Server error.');
        var callCount = 0;
        when(() => mockUseCase.call()).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) return const Right([breedTestData]);
          return const Left(failure);
        });

        final container = makeContainer(mockUseCase);
        await container.read(breedsProvider.future);

        // When
        await container.read(breedsProvider.notifier).refresh();

        // Then
        expect(container.read(breedsProvider).hasError, isTrue);
        expect(container.read(breedsProvider).error, isA<ServerFailure>());
      });

      test('should pass through AsyncLoading before completing', () async {
        // Given
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));

        final container = makeContainer(mockUseCase);
        await container.read(breedsProvider.future);

        final states = <AsyncValue<List<Breed>>>[];
        container.listen(breedsProvider, (_, next) => states.add(next));

        // When
        await container.read(breedsProvider.notifier).refresh();

        // Then
        expect(states.first, isA<AsyncLoading>());
        expect(states.last.value, [breedTestData]);
      });
    });

    group('search', () {
      setUp(() {
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const Right([breedTestData]));
      });

      test('should filter breeds by name (case-insensitive)', () async {
        // Given
        final container = makeContainer(mockUseCase);
        await container.read(breedsProvider.future);

        // When
        container.read(breedsProvider.notifier).search('abys');

        // Then
        expect(container.read(breedsProvider).value, [breedTestData]);
      });

      test('should return empty list when no breed matches query', () async {
        // Given
        final container = makeContainer(mockUseCase);
        await container.read(breedsProvider.future);

        // When
        container.read(breedsProvider.notifier).search('xyz');

        // Then
        expect(container.read(breedsProvider).value, isEmpty);
      });

      test('should restore full list when query is cleared', () async {
        // Given
        final container = makeContainer(mockUseCase);
        await container.read(breedsProvider.future);
        container.read(breedsProvider.notifier).search('abys');

        // When
        container.read(breedsProvider.notifier).search('');

        // Then
        expect(container.read(breedsProvider).value, [breedTestData]);
      });

      test('should trim whitespace before filtering', () async {
        // Given
        final container = makeContainer(mockUseCase);
        await container.read(breedsProvider.future);

        // When
        container.read(breedsProvider.notifier).search('   ');

        // Then
        expect(container.read(breedsProvider).value, [breedTestData]);
      });
    });
  });
}
