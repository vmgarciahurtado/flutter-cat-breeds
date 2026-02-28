import 'package:dartz/dartz.dart';

import 'package:cat_breeds/features/breeds/domain/entities/breed.dart';
import 'package:cat_breeds/features/breeds/domain/repositories/breeds_repository.dart';
import 'package:cat_breeds/core/error/failure.dart';

class GetBreedsUseCase {
  final BreedsRepository _repository;
  const GetBreedsUseCase(this._repository);

  Future<Either<Failure, List<Breed>>> call() => _repository.getBreeds();
}
