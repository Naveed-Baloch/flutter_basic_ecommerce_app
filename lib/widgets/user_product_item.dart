import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/edit_prod_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  var scafold;
  Product existingProduct;

  UserProductItem({
    this.title,
    this.imageUrl,
    this.id,
  });

  void _showSnakBar(BuildContext context, String message) {
    scafold.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // try{
          //  await Provider.of<Products>(context).additem(existingProduct);
          //   _showSnakBarError(context, 'Product Re-Added!');
          // }
          // catch(error)
          // {
          //   _showSnakBarError(context, 'Product Could Not Re-Added!');
          // }
        },
      ),
    ));
  }

  void _showSnakBarError(BuildContext context, String message) {
    scafold.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void deletePro(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false).deleteProduct(id);
      _showSnakBar(context, 'Deleted Successfully');
    } catch (error) {
      _showSnakBarError(context, 'Could not deleted! Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    scafold = Scaffold.of(context);
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(EditProductScreen.routName, arguments: id);
                    },
                    icon: Icon(Icons.edit),
                    color: Theme.of(context).primaryColor),
                IconButton(
                  onPressed: () => deletePro(context),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
