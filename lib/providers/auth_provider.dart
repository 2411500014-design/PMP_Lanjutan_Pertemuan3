import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // State pengguna sekarang berupa objek User? dari Firebase,
  // menggantikan token dummy pada Pertemuan 3.
  User? _user;
  String? _token;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  String? get token => _token;

  // Dipanggil oleh listener authStateChanges() di main.dart.
  Future<void> setUser(User? user) async {
    _user = user;
    _token = user == null ? null : await user.getIdToken();
    notifyListeners();
  }

  // 1. Pendaftaran (Register)
  Future<String?> register(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _pesanError(e);
    }
  }

  // 2. Masuk (Login)
  Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _pesanError(e);
    }
  }

  // 3. Keluar (Logout)
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Pengolahan pesan error berbahasa Indonesia.
  String _pesanError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah (minimal 6 karakter).';
      case 'user-not-found':
        return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'user-disabled':
        return 'Akun ini dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi beberapa saat.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      case 'operation-not-allowed':
        return 'Metode Email/Password belum diaktifkan di Firebase Console.';
      default:
        return e.message ?? 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
