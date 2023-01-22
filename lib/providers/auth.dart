import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  // Future<void> _authenticate(
  //     String email, String password, String urlSegment) async {}

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        ('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAuEB1cb1WNaJ9cNAU5Mf8xXoucmMgA7Sk'));
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signup(String? email, String? password) async {
    return _authenticate(email!, password!, 'signUp');
  }

  Future<void> login(String? email, String? password) async {
    return _authenticate(email!, password!, 'signInWithPassword');
  }
}
