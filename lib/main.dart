import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_prod_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/chart.dart';
import './providers/orders.dart';
import './screens/order_screen.dart';
import './screens/user_products.dart';
import './screens/auth_screen.dart.dart';
import './screens/splash_screen.dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (ctx, auth, oldproduct) => Products(auth.token, auth.userId,
              oldproduct != null ? oldproduct.items : []),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (ctx, auth, previousOrder) => Orders(auth.token, auth.userId,
              previousOrder == null ? [] : previousOrder.orders),
        ),
        ChangeNotifierProvider.value(value: Cart())
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'My Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          initialRoute: '/',
          routes: {
            '/': (ctx) => auth.isAuth()
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.autoSignIn(),
                    builder: (ctx, autoScreen) {
                      if (autoScreen.connectionState == ConnectionState.waiting)
                        return SplashScreen();
                      else {
                        if (autoScreen.data == true)
                          return ProductOverviewScreen();
                      }
                      return AuthScreen();
                    },
                  ),
            ProductDetailScreen.routName: (ctx) => ProductDetailScreen(),
            CartScreen.routName: (ctx) => CartScreen(),
            OrderScreen.routName: (ctx) => OrderScreen(),
            UserProductsScreen.routName: (ctx) => UserProductsScreen(),
            EditProductScreen.routName: (ctx) => EditProductScreen(),
          },
          onUnknownRoute: (setting) {
            return MaterialPageRoute(builder: (ctx) => ProductOverviewScreen());
          },
          onGenerateRoute: (setting) {
            return MaterialPageRoute(builder: (ctx) => ProductOverviewScreen());
          },
        ),
      ),
    );
  }
}
