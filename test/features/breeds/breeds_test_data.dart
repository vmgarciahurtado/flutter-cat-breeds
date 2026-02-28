import 'package:catbreeds/features/breeds/data/models/breed_model.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';

const breedModelTestData = BreedModel(
  id: 'abys',
  name: 'Abyssinian',
  description: 'Easy to care for.',
  origin: 'Egypt',
  lifeSpan: '14 - 15',
  referenceImageId: '0XYvRd7oD',
);

const breedTestData = Breed(
  id: 'abys',
  name: 'Abyssinian',
  description: 'Easy to care for.',
  origin: 'Egypt',
  lifeSpan: '14 - 15',
  imageId: '0XYvRd7oD',
);

const breedTestDataWithFlag = Breed(
  id: 'abys',
  name: 'Abyssinian',
  description: 'Easy to care for.',
  origin: 'Egypt',
  lifeSpan: '14 - 15',
  imageId: '0XYvRd7oD',
  countryCode: 'EG',
);

const breedTestDataWithTemperament = Breed(
  id: 'abys',
  name: 'Abyssinian',
  description: 'Easy to care for.',
  origin: 'Egypt',
  lifeSpan: '14 - 15',
  imageId: '0XYvRd7oD',
  temperament: 'Active, Energetic',
);

const breedTestDataWithRatings = Breed(
  id: 'abys',
  name: 'Abyssinian',
  description: 'Easy to care for.',
  origin: 'Egypt',
  lifeSpan: '14 - 15',
  imageId: '0XYvRd7oD',
  intelligence: 5,
  adaptability: 4,
);

const breedTestDataWithWeight = Breed(
  id: 'abys',
  name: 'Abyssinian',
  description: 'Easy to care for.',
  origin: 'Egypt',
  lifeSpan: '14 - 15',
  imageId: '0XYvRd7oD',
  weight: Weight(metric: '3 - 5', imperial: '7 - 10'),
);

const breedTestDataNoImage = Breed(
  id: 'abys',
  name: 'Abyssinian',
  description: 'Easy to care for.',
  origin: 'Egypt',
  lifeSpan: '14 - 15',
  imageId: null,
);
