import 'package:dartz/dartz.dart';

import 'package:cat_breeds/core/error/failure.dart';
import 'package:cat_breeds/features/breeds/domain/entities/breed.dart';

abstract interface class BreedsRepository {
  Future<Either<Failure, List<Breed>>> getBreeds();
}
