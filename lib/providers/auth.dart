import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String id;

  // Future<void> _authenticate(
  //     String email, String password, String urlSegment) async {}

  Future<void> singup(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAuEB1cb1WNaJ9cNAU5Mf8xXoucmMgA7Sk");

    try {
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAuEB1cb1WNaJ9cNAU5Mf8xXoucmMgA7Sk");

    try {
      http.Response response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
