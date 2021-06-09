import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:shop_app/model/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userid;
  DateTime _expiry_Date;
  Timer authtime;

  bool isAuth() {
    if (token == null) return false;
    return true;
    // return token != null;
  }

  String get userId {
    return _userid;
  }

  String get token {
    if (_token != null &&
        _expiry_Date.isAfter(DateTime.now()) &&
        _userid != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate({email, password, method}) async {
    final String Url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=AIzaSyDGUQuFnI2DZPNKyArtu9irIcvv_eqH82s';

    final response = await http.post(Uri.parse(Url),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    final extractedData = json.decode(response.body);
    if (extractedData['error'] != null) {
      throw HttpException(extractedData['error']['message']);
    }
    _token = extractedData['idToken'];
    _userid = extractedData['localId'];
    _expiry_Date = DateTime.now()
        .add(Duration(seconds: int.parse(extractedData['expiresIn'])));
    autoLogOut();
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    final userdata = json.encode({
      'token': _token,
      'userId': _userid,
      'expiryDate': _expiry_Date.toIso8601String()
    });
    await pref.setString('userData', userdata);
    print('data is saved');
  }

  Future<void> signUp({String email, String password}) async {
    return _authenticate(email: email, password: password, method: 'signUp');
  }

  Future<void> signIn({String email, String password}) async {
    return _authenticate(
        email: email, password: password, method: 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _userid = null;
    _expiry_Date = null;
    if (authtime != null) {
      authtime.cancel();
      authtime = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> autoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedMap =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      if (DateTime.parse(extractedMap['expiryDate']).isBefore(DateTime.now()))
        return false;
      _token = extractedMap['token'];
      _userid = extractedMap['userId'];
      _expiry_Date = DateTime.parse(extractedMap['expiryDate']);
      notifyListeners();
      autoLogOut();
      return true;
    } else {
      return false;
    }
  }

  void autoLogOut() {
    if (authtime != null) {
      authtime.cancel();
    } else {
      final expiryTime = _expiry_Date.difference(DateTime.now()).inSeconds;
      authtime = Timer(Duration(seconds: expiryTime), logOut);
    }
  }
}
