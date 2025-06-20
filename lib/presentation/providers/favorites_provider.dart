import 'package:flutter/material.dart';
import '../../core/models/photo.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Photo> _favorites = [];

  List<Photo> get favorites => _favorites;

  void toggleFavorite(Photo photo) {
    final isExist = _favorites.any((p) => p.id == photo.id);
    if (isExist) {
      _favorites.removeWhere((p) => p.id == photo.id);
    } else {
      _favorites.add(photo);
    }
    notifyListeners();
  }

  bool isFavorite(Photo photo) {
    return _favorites.any((p) => p.id == photo.id);
  }
}
