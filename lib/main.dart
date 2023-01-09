import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.orange),
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: ((ctx) => const ProductDetailScreen()),
          CartScreen.routeName: ((ctx) => const CartScreen()),
          OrdersScreen.routeName: ((ctx) => OrdersScreen()),
          UserProductScreen.routeName: ((ctx) => const UserProductScreen()),
          EditProductScreen.routeName: ((ctx) => const EditProductScreen())
        },
      ),
    );
  }
}
