import 'package:cat_breeds/core/constants/strings.dart';
import 'package:cat_breeds/core/error/failure.dart';
import 'package:cat_breeds/core/routes/routes.dart';
import 'package:cat_breeds/features/breeds/presentation/providers/breeds_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'widgets/widgets.dart';

class BreedsPage extends ConsumerWidget {
  const BreedsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(breedsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBar(
              hintText: AppStrings.searchHint,
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              backgroundColor: WidgetStateProperty.all(theme.cardColor),
              side: WidgetStateProperty.all(
                BorderSide(color: theme.colorScheme.outline),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onChanged: (q) => ref.read(breedsProvider.notifier).search(q),
              leading: Icon(Icons.search, color: theme.colorScheme.onSurface),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(breedsProvider.notifier).refresh(),
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorView(
                  failure: e as Failure,
                  onRetry: () => ref.read(breedsProvider.notifier).refresh(),
                ),
                data: (breeds) {
                  if (breeds.isEmpty) {
                    return const Center(child: Text(AppStrings.noBreedsFound));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: breeds.length,
                    itemBuilder: (_, i) => BreedCard(
                      breed: breeds[i],
                      onTap: () => context.push(
                        AppRoutes.breedDetailPath(breeds[i].id),
                        extra: breeds[i],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
