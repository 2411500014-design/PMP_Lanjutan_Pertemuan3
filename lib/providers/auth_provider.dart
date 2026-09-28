import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // 1: state login.
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  Future<bool> login(String email, String password) async {
    // 2: simulasi request login (delay 1 detik).
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.length >= 6) {
      _isAuthenticated = true;
      _token = 'token_auth_dummy_12345';
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    // 3: reset state + notifyListeners().
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
  }
}
