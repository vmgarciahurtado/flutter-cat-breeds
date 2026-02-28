import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:catbreeds/core/network/dio_provider.dart';
import 'package:catbreeds/features/breeds/data/data.dart';
import 'package:catbreeds/features/breeds/domain/domain.dart';

part 'breeds_providers.g.dart';

@riverpod
BreedsApi breedsApi(Ref ref) => BreedsApi(ref.watch(dioProvider));

@riverpod
BreedsRepository breedsRepository(Ref ref) =>
    BreedsRepositoryImpl(ref.watch(breedsApiProvider));

@riverpod
GetBreedsUseCase getBreedsUseCase(Ref ref) =>
    GetBreedsUseCase(ref.watch(breedsRepositoryProvider));
