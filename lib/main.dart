import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_scree.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', '', []),
          update: (context, auth, previousProducts) => Products(
            auth.token == null ? '' : auth.token as String,
            auth.userId == null ? '' : auth.userId as String,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', '', []),
          update: (context, auth, previousOrders) => Orders(
              auth.token == null ? '' : auth.token as String,
              auth.userId == null ? '' : auth.userId as String,
              previousOrders == null ? [] : previousOrders.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.orange),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : AuthScreen(),
                  future: auth.tryToAutoLogin(),
                ),
          routes: {
            ProductDetailScreen.routeName: ((ctx) =>
                const ProductDetailScreen()),
            CartScreen.routeName: ((ctx) => const CartScreen()),
            OrdersScreen.routeName: ((ctx) => const OrdersScreen()),
            UserProductScreen.routeName: ((ctx) => const UserProductScreen()),
            EditProductScreen.routeName: ((ctx) => const EditProductScreen())
          },
        ),
      ),
    );
  }
}
