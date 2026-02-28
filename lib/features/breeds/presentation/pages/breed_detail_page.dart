import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds/core/constants/strings.dart';
import 'package:catbreeds/core/network/api_paths.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BreedDetailPage extends StatelessWidget {
  final Breed breed;
  const BreedDetailPage({super.key, required this.breed});

  InfoItem? _rated(String label, int? value) => value != null
      ? InfoItem(label, '$value ${AppStrings.labelOutOf5}')
      : null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageHeight = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: imageHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'breed-image-${breed.id}',
                  child: CachedNetworkImage(
                    imageUrl: ApiPaths.imageUrl(breed.imageId),
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(color: Colors.grey[200]),
                    errorWidget: (_, _, _) => Center(
                      child: Icon(
                        Icons.pets,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          breed.name,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      if (breed.countryCode != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl: ApiPaths.flagUrl(breed.countryCode!),
                            height: 28,
                            width: 42,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => const SizedBox.shrink(),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(breed.description, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  InfoSection(
                    title: AppStrings.sectionGeneral,
                    items: [
                      InfoItem(AppStrings.labelBreed, breed.name),
                      InfoItem(AppStrings.labelOrigin, breed.origin),
                      InfoItem(AppStrings.labelLifeSpan, breed.lifeSpan),
                      if (breed.temperament != null)
                        InfoItem(
                          AppStrings.labelTemperament,
                          breed.temperament!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InfoSection(
                    title: AppStrings.sectionPersonality,
                    items: [
                      _rated(AppStrings.labelIntelligence, breed.intelligence),
                      _rated(AppStrings.labelAdaptability, breed.adaptability),
                      _rated(AppStrings.labelAffection, breed.affectionLevel),
                      _rated(AppStrings.labelEnergy, breed.energyLevel),
                      _rated(AppStrings.labelSocialNeeds, breed.socialNeeds),
                      _rated(
                        AppStrings.labelChildFriendly,
                        breed.childFriendly,
                      ),
                      _rated(AppStrings.labelDogFriendly, breed.dogFriendly),
                      _rated(AppStrings.labelStranger, breed.strangerFriendly),
                    ].whereType<InfoItem>().toList(),
                  ),
                  const SizedBox(height: 12),
                  InfoSection(
                    title: AppStrings.sectionCare,
                    items: [
                      _rated(AppStrings.labelGrooming, breed.grooming),
                      _rated(AppStrings.labelShedding, breed.sheddingLevel),
                      _rated(AppStrings.labelHealth, breed.healthIssues),
                      _rated(AppStrings.labelVocalisation, breed.vocalisation),
                    ].whereType<InfoItem>().toList(),
                  ),
                  if (breed.weight != null) ...[
                    const SizedBox(height: 12),
                    InfoSection(
                      title: AppStrings.sectionWeight,
                      items: [
                        InfoItem(
                          AppStrings.labelMetric,
                          '${breed.weight!.metric} ${AppStrings.labelKg}',
                        ),
                        InfoItem(
                          AppStrings.labelImperial,
                          '${breed.weight!.imperial} ${AppStrings.labelLbs}',
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
