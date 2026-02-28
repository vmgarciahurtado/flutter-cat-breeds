import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/domain/repositories/breeds_repository.dart';
import 'package:catbreeds/features/breeds/domain/usecases/get_breeds_usecase.dart';

import '../../breeds_test_data.dart';

class MockBreedsRepository extends Mock implements BreedsRepository {}

void main() {
  late MockBreedsRepository mockRepository;
  late GetBreedsUseCase useCase;

  setUp(() {
    mockRepository = MockBreedsRepository();
    useCase = GetBreedsUseCase(mockRepository);
  });

  group('GetBreedsUseCase', () {
    test('should return list of breeds when repository succeeds', () async {
      // Given
      when(
        () => mockRepository.getBreeds(),
      ).thenAnswer((_) async => const Right([breedTestData]));

      // When
      final result = await useCase.call();

      // Then
      expect(result, const Right([breedTestData]));
      verify(() => mockRepository.getBreeds()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Given
      const failure = Failure.network('No internet connection.');
      when(
        () => mockRepository.getBreeds(),
      ).thenAnswer((_) async => const Left(failure));

      // When
      final result = await useCase.call();

      // Then
      expect(result, const Left(failure));
      verify(() => mockRepository.getBreeds()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when server returns an error', () async {
      // Given
      const failure = Failure.server('Server error.');
      when(
        () => mockRepository.getBreeds(),
      ).thenAnswer((_) async => const Left(failure));

      // When
      final result = await useCase.call();

      // Then
      expect(result, const Left(failure));
      verify(() => mockRepository.getBreeds()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should call repository only once per call', () async {
      // Given
      when(
        () => mockRepository.getBreeds(),
      ).thenAnswer((_) async => const Right([breedTestData]));

      // When
      await useCase.call();

      // Then
      verify(() => mockRepository.getBreeds()).called(1);
    });

    test(
      'should return empty list when repository returns no breeds',
      () async {
        // Given
        when(
          () => mockRepository.getBreeds(),
        ).thenAnswer((_) async => const Right(<Breed>[]));

        // When
        final result = await useCase.call();

        // Then
        expect(result, const Right(<Breed>[]));
      },
    );
  });
}
