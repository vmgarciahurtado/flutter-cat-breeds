import 'package:cat_breeds/core/network/api_paths.dart';
import 'package:cat_breeds/features/breeds/data/models/breed_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'breeds_api.g.dart';

@RestApi()
abstract class BreedsApi {
  factory BreedsApi(Dio dio, {String baseUrl}) = _BreedsApi;

  @GET(ApiPaths.breedsPath)
  Future<List<BreedModel>> getBreeds();
}
