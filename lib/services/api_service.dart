import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constant.dart';

class ApiService extends ChangeNotifier {
  double _balance = 0.0;
  bool _isLoading = false;
  String? _errorMessage;

  double get balance => _balance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Récupérer le solde du portefeuille via le numéro de téléphone du client
  Future<void> fetchWalletBalance(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/wallets/$phone/balance'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // On s'adapte au format JSON (soit un double direct, soit un objet wallet)
        if (data is num) {
          _balance = data.toDouble();
        } else if (data is Map && data.containsKey('balance')) {
          _balance = (data['balance'] as num).toDouble();
        }
      } else {
        _errorMessage = 'Impossible de récupérer le solde (${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = 'Erreur de connexion au serveur backend';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}