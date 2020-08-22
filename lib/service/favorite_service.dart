import 'package:ikus_app/model/feature.dart';

class FavoriteService {

  static List<Feature> _favorites = [ Feature.MAP, Feature.MENSA, Feature.LINKS ];

  static List<Feature> getFavorites() {
    return _favorites;
  }

  static void addFavorite(Feature feature) {
    _favorites = [ ..._favorites, feature ].toSet().toList()..sort((a, b) => a.index - b.index);
  }

  static void removeFavorite(Feature feature) {
    _favorites = _favorites.where((f) => f != feature).toList();
  }

  static void toggleFavorite(Feature feature) {
    if (isFavorite(feature))
      removeFavorite(feature);
    else
      addFavorite(feature);
  }

  static bool isFavorite(Feature feature) {
    return _favorites.indexOf(feature) != -1;
  }
}