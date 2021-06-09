import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_prod_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatefulWidget {
  static const String routName = '/user-product';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void> _refeshProductData() async {
    await Provider.of<Products>(context, listen: false).getSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routName);
              },
            )
          ],
        ),
        drawer: CustomDrawer(),
        body: FutureBuilder(
          future: _refeshProductData(),
          builder: (ctx, datasnapshot) {
            if (datasnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Loading Products Please wait!'),
                  ],
                ),
              );
            } else {
              if (datasnapshot.error != null) {
                return Center(child: Text(datasnapshot.error.toString()));
              } else {
                return Consumer<Products>(
                  builder: (ctx, productsData, child) => RefreshIndicator(
                    onRefresh: _refeshProductData,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (ctx, index) {
                          return UserProductItem(
                            title: productsData.items[index].title,
                            imageUrl: productsData.items[index].imageUrl,
                            id: productsData.items[index].id,
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ));
  }
}
