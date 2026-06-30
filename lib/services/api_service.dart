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
  Future<bool> makeTransfer(String senderPhone, String receiverPhone, double amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/wallets/transfer'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'senderPhone': senderPhone,
          'receiverPhone': receiverPhone,
          'amount': amount,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si le transfert est réussi, on met à jour le solde local
        await fetchWalletBalance(senderPhone);
        return true;
      } else {
        _errorMessage = 'Échec du transfert (${response.statusCode})';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur de connexion au serveur backend';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
   }
   // Effectuer le paiement groupé de factures
  Future<bool> payBills({required String phone, required double totalAmount, required List<String> billNames}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/wallets/pay-bills'), // Modifie l'endpoint selon la doc exacte de ton API au besoin
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': phone,
          'amount': totalAmount,
          'description': 'Paiement factures: ${billNames.join(", ")}',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Mise à jour immédiate du solde local après paiement réussi
        await fetchWalletBalance(phone);
        return true;
      } else {
        _errorMessage = 'Échec du paiement des factures (${response.statusCode})';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur de connexion au serveur pour le paiement';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}