class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const breeds = '/breeds';
  static const breedDetail = '/breeds/:id';

  static String breedDetailPath(String id) => '/breeds/$id';
}
