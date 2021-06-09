import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void _setFavoriteStatus(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token,String userId) async {
    final String URL = 'https://chat-app-9f9cf.firebaseio.com/favorits/$userId/$id.json/?auth=$token';
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(Uri.parse(URL),
          body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavoriteStatus(oldStatus);
      }
    } catch (error) {
      _setFavoriteStatus(oldStatus);
    }
    notifyListeners();
  }
}
