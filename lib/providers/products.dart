import 'package:flutter/material.dart';
import 'package:shop_app/model/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/appconstant.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String token;
  final String userId;

  Products(this.token, this.userId, this._items);

//this is dummy data
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  List<Product> get items {
    return [..._items];
  }

  Product getByID(String id) {
    return _items.firstWhere((element) {
      return element.id == id;
    });
  }

  List<Product> get favorite {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> getSetData([bool filterMode = false]) async {
    try {
      _items = [];
      final List<Product> tempproducts = [];
      final filterString =
          filterMode ? '&orderBy="creatorId"&equalTo="$userId"' : '';
      final response = await http
          .get(Uri.parse(AppConstant.URL + '?auth=$token$filterString'));

      final extractedMapData =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedMapData == null) return;
      final String urlFav =
          'https://chat-app-9f9cf.firebaseio.com/favorits/$userId.json/?auth=$token';
      final responseFav = await http.get(Uri.parse(urlFav));
      final favMap = json.decode(responseFav.body);
      extractedMapData.forEach((prodid, proData) {
        tempproducts.add(Product(
          id: prodid,
          title: proData['title'],
          price: proData['price'],
          description: proData['description'],
          isFavorite: favMap == null ? false : favMap[prodid] ?? false,
          imageUrl: proData['imageUrl'],
        ));
        _items = tempproducts;
        notifyListeners();
      });
    } catch (error) {
       throw error;
    }
  }

  Future<void> additem(Product product) async {
    //return  asyn automatically return the future
    try {
      final response = await http.post(
        Uri.parse(AppConstant.URL + '?auth=$token'),
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'creatorId': userId
        }),
      );
// this is the then code which will be excuted after await completes
      final final_product = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl);
      _items.insert(0, final_product);
      notifyListeners();
    } //instead of calling .catcherror on then we use the try catch block to used this
    catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final pro_index = _items.indexWhere((product) => product.id == id);
    final String URL =
        'https://chat-app-9f9cf.firebaseio.com/products/$id.json/';
    if (pro_index >= 0) {
      await http.patch(Uri.parse(URL + '?auth=$token'),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl
          }));
      _items[pro_index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final String URL =
        'https://chat-app-9f9cf.firebaseio.com/products/$id.json/';
    final index = _items.indexWhere((element) => element.id == id);
    Product existingProduct = _items.elementAt(index);
    _items.removeAt(_items.indexWhere((element) => element.id == id));
    notifyListeners();
    final response = await http.delete(Uri.parse(URL + '?auth=$token'));
    if (response.statusCode >= 400) {
      _items.insert(index, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the item');
    }
    existingProduct = null;
  }
}
