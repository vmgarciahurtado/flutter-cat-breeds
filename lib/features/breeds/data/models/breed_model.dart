import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cat_breeds/features/breeds/domain/entities/breed.dart';

part 'breed_model.freezed.dart';
part 'breed_model.g.dart';

@freezed
abstract class BreedModel with _$BreedModel {
  const factory BreedModel({
    required String id,
    required String name,
    required String description,
    required String origin,
    String? temperament,
    @JsonKey(name: 'life_span') required String lifeSpan,
    @JsonKey(name: 'reference_image_id') String? referenceImageId,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'country_codes') String? countryCodes,
    @JsonKey(name: 'cfa_url') String? cfaUrl,
    @JsonKey(name: 'vetstreet_url') String? vetstreetUrl,
    @JsonKey(name: 'vcahospitals_url') String? vcahospitalsUrl,
    @JsonKey(name: 'wikipedia_url') String? wikipediaUrl,
    @JsonKey(name: 'alt_names') String? altNames,
    int? intelligence,
    int? adaptability,
    @JsonKey(name: 'affection_level') int? affectionLevel,
    @JsonKey(name: 'energy_level') int? energyLevel,
    @JsonKey(name: 'social_needs') int? socialNeeds,
    @JsonKey(name: 'child_friendly') int? childFriendly,
    @JsonKey(name: 'dog_friendly') int? dogFriendly,
    @JsonKey(name: 'stranger_friendly') int? strangerFriendly,
    int? grooming,
    @JsonKey(name: 'shedding_level') int? sheddingLevel,
    @JsonKey(name: 'health_issues') int? healthIssues,
    int? vocalisation,
    int? indoor,
    int? lap,
    int? experimental,
    int? hairless,
    int? natural,
    int? rare,
    int? rex,
    @JsonKey(name: 'suppressed_tail') int? suppressedTail,
    @JsonKey(name: 'short_legs') int? shortLegs,
    int? hypoallergenic,
    WeightModel? weight,
  }) = _BreedModel;

  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);
}

@freezed
abstract class WeightModel with _$WeightModel {
  const factory WeightModel({
    required String metric,
    required String imperial,
  }) = _WeightModel;

  factory WeightModel.fromJson(Map<String, dynamic> json) =>
      _$WeightModelFromJson(json);
}

extension BreedModelMapper on BreedModel {
  Breed toEntity() => Breed(
    id: id,
    name: name,
    description: description,
    origin: origin,
    temperament: temperament,
    lifeSpan: lifeSpan,
    imageId: referenceImageId,
    countryCode: countryCode,
    countryCodes: countryCodes,
    cfaUrl: cfaUrl,
    vetstreetUrl: vetstreetUrl,
    vcahospitalsUrl: vcahospitalsUrl,
    wikipediaUrl: wikipediaUrl,
    altNames: altNames,
    intelligence: intelligence,
    adaptability: adaptability,
    affectionLevel: affectionLevel,
    energyLevel: energyLevel,
    socialNeeds: socialNeeds,
    childFriendly: childFriendly,
    dogFriendly: dogFriendly,
    strangerFriendly: strangerFriendly,
    grooming: grooming,
    sheddingLevel: sheddingLevel,
    healthIssues: healthIssues,
    vocalisation: vocalisation,
    indoor: indoor,
    lap: lap,
    hairless: hairless,
    natural: natural,
    rare: rare,
    rex: rex,
    suppressedTail: suppressedTail,
    shortLegs: shortLegs,
    hypoallergenic: hypoallergenic,
    weight: weight?.toEntity(),
  );
}

extension WeightModelMapper on WeightModel {
  Weight toEntity() => Weight(metric: metric, imperial: imperial);
}
