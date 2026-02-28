import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cat_breeds/features/breeds/di/breeds_providers.dart';
import 'package:cat_breeds/features/breeds/domain/entities/breed.dart';

part 'breeds_provider.g.dart';

@riverpod
class BreedsNotifier extends _$BreedsNotifier {
  List<Breed> _breeds = [];

  @override
  Future<List<Breed>> build() async {
    final result = await ref.read(getBreedsUseCaseProvider).call();
    return result.fold(
      (failure) => throw failure,
      (breeds) => _breeds = breeds,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final result = await ref.read(getBreedsUseCaseProvider).call();
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (breeds) => AsyncData(_breeds = breeds),
    );
  }

  void search(String query) {
    final q = query.trim();
    state = AsyncData(
      q.isEmpty
          ? _breeds
          : _breeds
                .where((b) => b.name.toLowerCase().contains(q.toLowerCase()))
                .toList(),
    );
  }
}
