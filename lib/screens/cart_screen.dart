import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/chart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/card_items.dart';

class CartScreen extends StatefulWidget {
  static const String routName = '/cart_screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _orderUploading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Chip(
                    label: Text(
                      '\$${(cart.totalAmount).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: (cart.totalAmount <= 0 || _orderUploading)
                        ? null
                        : () async {
                            setState(() {
                              _orderUploading = true;
                            });
                                await Provider.of<Orders>(context, listen: false)
                                    .addOrder(cart.items.values.toList(),
                                        cart.totalAmount);
                            setState(() {
                              _orderUploading = false;
                            });
                            cart.clear();
                          },
                    child: _orderUploading
                        ? CircularProgressIndicator()
                        : Text(
                            'Order Now',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartitem,
              itemBuilder: (ctx, index) => LsCardItem(
                  cart.items.values.toList()[index].id,
                  cart.items.values.toList()[index].title,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.keys.toList()[index]),
            ),
          )
        ],
      ),
    );
  }
}
