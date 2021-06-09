import 'package:flutter/foundation.dart';
import '../providers/chart.dart';
import 'package:http/http.dart' as http;
import '../util/appconstant.dart';
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CardItem> products;
  final DateTime datetime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders=[];
  final String token;
  final String userId;

  Orders(this.token,this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchSetData() async {
    _orders = [];
    final response = await http.get(Uri.parse(AppConstant.ORDER_URL+'/$userId'+'.json'+'?auth=$token'));
    List<OrderItem> temporder = [];
    final extractedMapData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedMapData == null) return;
    extractedMapData.forEach((orderid, orderData) {
      temporder.add(OrderItem(
        id: orderid,
        amount: orderData['amount'],
        datetime: DateTime.parse(orderData['datetime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (product) => CardItem(
                  id: product['id'],
                  title: product['title'],
                  quantity: product['quantity'],
                  price: product['price']),
            )
            .toList(),
      ));
    });
    _orders = temporder;
    notifyListeners();
  }

  Future<void> addOrder(List<CardItem> cardProducts, double total) async {
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(AppConstant.ORDER_URL+'/$userId'+'.json'+'?auth=$token'),
        body: json.encode(
          {
            'amount': total,
            'datetime': timeStamp.toIso8601String(),
            'products': cardProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList()
          },
        ),
      );
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cardProducts,
              datetime: timeStamp));
      notifyListeners();
    } catch (error) {}
  }

  void removeItem(String productId) {}
}
