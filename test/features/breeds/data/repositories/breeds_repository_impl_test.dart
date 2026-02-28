import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/data/datasources/remote/breeds_api.dart';
import 'package:catbreeds/features/breeds/data/models/breed_model.dart';
import 'package:catbreeds/features/breeds/data/repositories/breeds_repository_impl.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';

import '../../breeds_test_data.dart';

class MockBreedsApi extends Mock implements BreedsApi {}

void main() {
  late MockBreedsApi mockApi;
  late BreedsRepositoryImpl repository;

  setUp(() {
    mockApi = MockBreedsApi();
    repository = BreedsRepositoryImpl(mockApi);
  });

  group('BreedsRepositoryImpl', () {
    group('getBreeds', () {
      test('should return list of breeds when api call succeeds', () async {
        // Given
        when(
          () => mockApi.getBreeds(),
        ).thenAnswer((_) async => [breedModelTestData]);

        // When
        final result = await repository.getBreeds();

        // Then
        expect(result.isRight(), true);
        expect(
          result.fold((l) => null, (r) => r),
          equals(<Breed>[breedTestData]),
        );
        verify(() => mockApi.getBreeds()).called(1);
        verifyNoMoreInteractions(mockApi);
      });

      test('should return NetworkFailure on connection timeout', () async {
        // Given
        when(() => mockApi.getBreeds()).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // When
        final result = await repository.getBreeds();

        // Then
        expect(result.isLeft(), true);
        expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
      });

      test('should return NetworkFailure on connection error', () async {
        // Given
        when(() => mockApi.getBreeds()).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionError,
          ),
        );

        // When
        final result = await repository.getBreeds();

        // Then
        expect(result.isLeft(), true);
        expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
      });

      test('should return ServerFailure on bad response', () async {
        // Given
        when(() => mockApi.getBreeds()).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 500,
              statusMessage: 'Internal Server Error',
            ),
          ),
        );

        // When
        final result = await repository.getBreeds();

        // Then
        expect(result.isLeft(), true);
        expect(result.fold((f) => f, (_) => null), isA<ServerFailure>());
      });

      test('should return UnknownFailure on unexpected error', () async {
        // Given
        when(() => mockApi.getBreeds()).thenThrow(Exception('Unexpected'));

        // When
        final result = await repository.getBreeds();

        // Then
        expect(result.isLeft(), true);
        expect(result.fold((f) => f, (_) => null), isA<UnknownFailure>());
      });

      test('should return empty list when api returns no breeds', () async {
        // Given
        when(() => mockApi.getBreeds()).thenAnswer((_) async => <BreedModel>[]);

        // When
        final result = await repository.getBreeds();

        // Then
        expect(result.isRight(), true);
        expect(result.fold((l) => null, (r) => r), equals(<Breed>[]));
        verify(() => mockApi.getBreeds()).called(1);
        verifyNoMoreInteractions(mockApi);
      });
    });
  });
}
