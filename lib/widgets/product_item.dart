import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/chart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routName,
                  arguments: product.id);
            },
            child: Image.network(product.imageUrl, fit: BoxFit.cover)),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, child) {
              return IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  final auth = Provider.of<Auth>(context, listen: false);
                  product.toggleFavorite(auth.token, auth.userId);
                },
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart_outlined,
                color: Theme.of(context).accentColor),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              // ignore: deprecated_member_use
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Add To Cart'),
                action: SnackBarAction(
                  label: 'undo',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                    print('product removed from the cart');
                  },
                ),
              ));
            },
          ),
        ),
        header: GridTileBar(
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            child: FittedBox(
                child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(product.price.toString() + '\$',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            )),
          ),
        ),
      ),
    );
  }
}
