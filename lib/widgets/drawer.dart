import 'package:flutter/material.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_products.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.reorder),
            title: Text('Your Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Manage Products'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductsScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('LogOut'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context,listen: false).logOut();
            },
          )
        ],
      ),
    );
  }
}
