import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-update-a338f-default-rtdb.europe-west1.firebasedatabase.app/orders.json');
    final timeStamp = DateTime.now();
    try {
      http.Response response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'DateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)["name"],
            amount: total,
            datetime: DateTime.now(),
            products: cartProducts),
      );
      notifyListeners();
    } catch (onError) {
      // ignore: avoid_print
      print(onError);
      // ignore: use_rethrow_when_possible
      throw onError;
    }
  }
}
