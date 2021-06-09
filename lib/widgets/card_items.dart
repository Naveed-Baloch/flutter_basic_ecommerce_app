import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/chart.dart';

class LsCardItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productid;

  LsCardItem(this.id, this.title, this.price, this.quantity, this.productid);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removwItem(productid);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Delete the Cart Item'),
                  content: Text('it will delete the item'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('No'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('yes')),
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('\$${price}'),
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('\$${price * quantity}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
