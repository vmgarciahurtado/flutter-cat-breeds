class ApiPaths {
  static const baseUrl = 'https://api.thecatapi.com/v1';
  static const breedsPath = '/breeds';
  static const searchPath = '/breeds/search';

  static String flagUrl(String countryCode) =>
      'https://flagsapi.com/$countryCode/flat/64.png';

  static String imageUrl(String? id) =>
      'https://cdn2.thecatapi.com/images/$id.jpg';
}
