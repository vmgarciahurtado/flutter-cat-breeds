import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed.freezed.dart';

@freezed
abstract class Breed with _$Breed {
  const factory Breed({
    required String id,
    required String name,
    required String description,
    required String origin,
    String? temperament,
    required String lifeSpan,
    String? imageId,
    String? countryCode,
    String? countryCodes,
    String? cfaUrl,
    String? vetstreetUrl,
    String? vcahospitalsUrl,
    String? wikipediaUrl,
    String? altNames,
    int? intelligence,
    int? adaptability,
    int? affectionLevel,
    int? energyLevel,
    int? socialNeeds,
    int? childFriendly,
    int? dogFriendly,
    int? strangerFriendly,
    int? grooming,
    int? sheddingLevel,
    int? healthIssues,
    int? vocalisation,
    int? indoor,
    int? lap,
    int? experimental,
    int? hairless,
    int? natural,
    int? rare,
    int? rex,
    int? suppressedTail,
    int? shortLegs,
    int? hypoallergenic,
    Weight? weight,
  }) = _Breed;
}

@freezed
abstract class Weight with _$Weight {
  const factory Weight({required String metric, required String imperial}) =
      _Weight;
}
