import 'package:dartz/dartz.dart';

import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';

abstract interface class BreedsRepository {
  Future<Either<Failure, List<Breed>>> getBreeds();
}
