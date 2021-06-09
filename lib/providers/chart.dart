import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier {
  Map<String, CardItem> _items = {};

  Map<String, CardItem> get items {
    return {..._items};
  }

  int get cartitem {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    var totalamount = 0.0;
    _items.forEach((key, cardItem) {
      totalamount += cardItem.price * cardItem.quantity;
    });
    notifyListeners();
    return totalamount;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existing_value) => CardItem(
              id: existing_value.id,
              title: existing_value.title,
              quantity: existing_value.quantity + 1,
              price: existing_value.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CardItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
      print('added with price' + price.toString());
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existing) => CardItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity - 1,
              price: existing.price));
    } else {
      removwItem(productId);
    }
    notifyListeners();
  }

  void removwItem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

class CardItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CardItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}
