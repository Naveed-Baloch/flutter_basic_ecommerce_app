import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    final pro_provider = Provider.of<Products>(context);
    final selectedpro = pro_provider.getByID(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedpro.title),
      ),
      body: Column(
        children: [
          Image.network(
            selectedpro.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              leading: CircleAvatar(
                  child: FittedBox(child: Text('\$${selectedpro.price}'))),
              title: Text(
                selectedpro.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              subtitle: Text(selectedpro.description),
            ),
          )
        ],
      ),
    );
  }
}
