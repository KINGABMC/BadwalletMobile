import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _currentPhone;

  String? get currentPhone => _currentPhone;
  bool get isAuthenticated => _currentPhone != null;

  // Initialisation : Vérification automatique au démarrage de l'application
  Future<void> checkLoginStatus() async {
    _currentPhone = await _storage.read(key: 'user_phone');
    notifyListeners();
  }

  // Enregistrement de la session client
  Future<bool> login(String phone) async {
    if (phone.trim().isNotEmpty) {
      await _storage.write(key: 'user_phone', value: phone.trim());
      _currentPhone = phone.trim();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Déconnexion / Suppression du cache
  Future<void> logout() async {
    await _storage.delete(key: 'user_phone');
    _currentPhone = null;
    notifyListeners();
  }
}