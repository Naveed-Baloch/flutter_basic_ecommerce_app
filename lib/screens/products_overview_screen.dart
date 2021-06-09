import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/chart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/product_gridBuilder.dart';
import 'package:provider/provider.dart';

enum MyMenuOption { Favorite, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showfavorite = false;
  var _productsloaded = false;
  var _init = true;

  Future<void> _refreshProducts() async
  {
   await Provider.of<Products>(context).getSetData();
  }


  @override
  void initState() {
    // Provider.of<Products>(context).getSetData(); this will not work because the context will not be available before initializing the widget

    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).getSetData();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_init) {
      await Provider.of<Products>(context).getSetData();
      setState(() {
        _productsloaded = true;
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) =>
                Badge(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routName);
                    },
                  ),
                  value: cart.cartitem.toString(),
                ),
          ),
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (index) {
                setState(() {
                  if (index == 0) {
                    _showfavorite = true;
                  } else {
                    _showfavorite = false;
                  }
                });
              },
              itemBuilder: (_) =>
              [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Theme
                            .of(context)
                            .accentColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Favorite')
                    ],
                  ),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.border_all,
                        color: Theme
                            .of(context)
                            .accentColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('All')
                    ],
                  ),
                  value: 1,
                )
              ]),
        ],
      ),
      body: _productsloaded
          ? RefreshIndicator(child: ProductGridBuilder(_showfavorite),
        onRefresh:_refreshProducts,)
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10.0,),
            Text('Loading Products Please wait!'),
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
