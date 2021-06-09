import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductGridBuilder extends StatelessWidget {
  bool _showfavorite;

  ProductGridBuilder(this._showfavorite);

  @override
  Widget build(BuildContext context) {
    final product_provider = Provider.of<Products>(context);
    final items =
        _showfavorite ? product_provider.favorite : product_provider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: items[index],
          child: ProductItem(
              // items[index].id,
              // items[index].imageUrl,
              // items[index].title,
              // items[index].price
              ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
