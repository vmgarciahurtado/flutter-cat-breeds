import 'package:cat_breeds/features/breeds/domain/entities/breed.dart';
import 'package:cat_breeds/features/breeds/presentation/pages/breed_detail_page.dart';
import 'package:go_router/go_router.dart';
import 'package:cat_breeds/features/splash/presentation/pages/splash_page.dart';
import 'package:cat_breeds/features/breeds/presentation/pages/breeds_page.dart';
import 'package:cat_breeds/core/routes/routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.breeds,
      builder: (context, state) => const BreedsPage(),
    ),
    GoRoute(
      path: AppRoutes.breedDetail,
      builder: (context, state) {
        final breed = state.extra;
        return BreedDetailPage(breed: breed as Breed);
      },
    ),
  ],
);
