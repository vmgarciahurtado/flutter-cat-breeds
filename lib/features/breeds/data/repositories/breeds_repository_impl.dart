import 'package:dartz/dartz.dart';
import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/core/network/api_executor.dart';
import 'package:catbreeds/features/breeds/data/datasources/remote/breeds_api.dart';
import 'package:catbreeds/features/breeds/data/models/breed_model.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/domain/repositories/breeds_repository.dart';

class BreedsRepositoryImpl implements BreedsRepository {
  final BreedsApi _api;
  const BreedsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, List<Breed>>> getBreeds() => executeApiCall(() async {
    final models = await _api.getBreeds();
    return models.map((m) => m.toEntity()).toList();
  });
}
