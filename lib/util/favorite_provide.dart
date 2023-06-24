import 'package:flutter/cupertino.dart';

class FavoriteProvide extends ChangeNotifier {
  bool _isFavorite = false;

  bool get value => _isFavorite;

  FavoriteProvide();

  void changeFavorite(bool favorite) {
    _isFavorite = favorite;
    notifyListeners();
  }
}