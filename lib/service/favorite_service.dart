import 'package:ikus_app/model/feature.dart';

class FavoriteService {

  static List<Feature> _favorites = [ Feature.LINKS, Feature.MAP, Feature.MENSA ];

  static List<Feature> getFavorites() {
    return _favorites;
  }

  static void addFavorite(Feature feature) {
    _favorites = [ ..._favorites, feature ].toSet().toList()..sort((a, b) => b.index - a.index);
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