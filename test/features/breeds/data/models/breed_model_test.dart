import 'package:catbreeds/features/breeds/data/models/breed_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BreedModel', () {
    test('fromJson should return a valid model', () {
      // Given
      final Map<String, dynamic> jsonMap = {
        "weight": {"imperial": "7  -  10", "metric": "3 - 5"},
        "id": "abys",
        "name": "Abyssinian",
        "cfa_url": "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx",
        "vetstreet_url": "http://www.vetstreet.com/cats/abyssinian",
        "vcahospitals_url":
            "https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian",
        "temperament": "Active, Energetic, Independent, Intelligent, Gentle",
        "origin": "Egypt",
        "country_codes": "EG",
        "country_code": "EG",
        "description":
            "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
        "life_span": "14 - 15",
        "indoor": 0,
        "lap": 1,
        "alt_names": "",
        "adaptability": 5,
        "affection_level": 5,
        "child_friendly": 3,
        "dog_friendly": 4,
        "energy_level": 5,
        "grooming": 1,
        "health_issues": 2,
        "intelligence": 5,
        "shedding_level": 2,
        "social_needs": 5,
        "stranger_friendly": 5,
        "vocalisation": 1,
        "experimental": 0,
        "hairless": 0,
        "natural": 1,
        "rare": 0,
        "rex": 0,
        "suppressed_tail": 0,
        "short_legs": 0,
        "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
        "hypoallergenic": 0,
        "reference_image_id": "0XYvRd7oD",
      };

      // When
      final result = BreedModel.fromJson(jsonMap);

      // Then
      expect(result.id, 'abys');
      expect(result.name, 'Abyssinian');
      expect(result.description, startsWith('The Abyssinian'));
      expect(result.origin, 'Egypt');
      expect(result.lifeSpan, '14 - 15');
      expect(result.referenceImageId, '0XYvRd7oD');
      expect(result.weight?.metric, '3 - 5');
      expect(result.weight?.imperial, '7  -  10');
    });
  });

  group('WeightModel', () {
    test('fromJson should return a valid model', () {
      // Given
      final Map<String, dynamic> jsonMap = {
        "imperial": "7  -  10",
        "metric": "3 - 5",
      };

      // When
      final result = WeightModel.fromJson(jsonMap);

      // Then
      expect(result.metric, '3 - 5');
      expect(result.imperial, '7  -  10');
    });
  });

  group('Mappers', () {
    test(
      'BreedModelMapper.toEntity should convert to Breed entity correctly',
      () {
        // Given
        const weightModel = WeightModel(metric: '3 - 5', imperial: '7 - 10');
        const model = BreedModel(
          id: 'abys',
          name: 'Abyssinian',
          description: 'Mock Description',
          origin: 'Egypt',
          lifeSpan: '14 - 15',
          referenceImageId: 'mock123',
          weight: weightModel,
          intelligence: 5,
          adaptability: 5,
          childFriendly: 4,
        );

        // When
        final entity = model.toEntity();

        // Then
        expect(entity.id, 'abys');
        expect(entity.name, 'Abyssinian');
        expect(entity.description, 'Mock Description');
        expect(entity.origin, 'Egypt');
        expect(entity.lifeSpan, '14 - 15');
        expect(entity.imageId, 'mock123');
        expect(entity.intelligence, 5);
        expect(entity.adaptability, 5);
        expect(entity.childFriendly, 4);
        expect(entity.weight?.metric, '3 - 5');
        expect(entity.weight?.imperial, '7 - 10');
      },
    );

    test(
      'WeightModelMapper.toEntity should convert to Weight entity correctly',
      () {
        // Given
        const model = WeightModel(metric: '3 - 5', imperial: '7 - 10');

        // When
        final entity = model.toEntity();

        // Then
        expect(entity.metric, '3 - 5');
        expect(entity.imperial, '7 - 10');
      },
    );
  });
}
