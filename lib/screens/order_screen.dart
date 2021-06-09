import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/order_item.dart' as ord;
import '../providers/orders.dart';

class OrderScreen extends StatefulWidget {
  static const String routName = '/order_screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isloading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, index) =>
                  ord.OrderItem(orderData.orders[index]),
            ),
      drawer: CustomDrawer(),
    );
  }
}
