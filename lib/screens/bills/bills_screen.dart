import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'XOF', decimalDigits: 0);

  // Liste des factures simulées selon les consignes du sujet
  final List<Map<String, dynamic>> _myBills = [
    {'id': 'b1', 'name': 'SENELEC Electricity', 'amount': 25000.0, 'checked': false},
    {'id': 'b2', 'name': 'WOYAFAL Rechargement', 'amount': 10000.0, 'checked': false},
    {'id': 'b3', 'name': 'Scolarité ISM / UCAD', 'amount': 75000.0, 'checked': false},
    {'id': 'b4', 'name': 'RAPIDO Badge Autoroute', 'amount': 5000.0, 'checked': false},
  ];

  double get _totalToPay {
    return _myBills
        .where((bill) => bill['checked'] == true)
        .fold(0.0, (sum, item) => sum + item['amount']);
  }

  void _processPayment() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final apiService = Provider.of<ApiService>(context, listen: false);

    final phone = authService.currentPhone;
    if (phone == null) return;

    List<String> selectedBillNames = _myBills
        .where((bill) => bill['checked'] == true)
        .map((bill) => bill['name'] as String)
        .toList();

    if (selectedBillNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner au moins une facture à payer.')),
      );
      return;
    }

    bool success = await apiService.payBills(
      phone: phone,
      totalAmount: _totalToPay,
      billNames: selectedBillNames,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paiement de ${_currencyFormat.format(_totalToPay)} effectué avec succès !'),
            backgroundColor: const Color(0xFF00A896),
          ),
        );
        Navigator.pop(context); // Retour au Dashboard
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(apiService.errorMessage ?? 'Erreur lors du paiement'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Règlement de factures', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF005C66),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              itemCount: _myBills.length,
              itemBuilder: (context, index) {
                final bill = _myBills[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: CheckboxListTile(
                    activeColor: const Color(0xFF00A896),
                    title: Text(
                      bill['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005C66)),
                    ),
                    subtitle: Text(
                      _currencyFormat.format(bill['amount']),
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                    value: bill['checked'],
                    onChanged: (bool? value) {
                      setState(() {
                        bill['checked'] = value ?? false;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          // Barre de résumé basse (Total + Bouton) inspirée de la charte moderne
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4)),
              ],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Montant Total', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(
                          _currencyFormat.format(_totalToPay),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005C66)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: apiService.isLoading || _totalToPay == 0 ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A896),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: apiService.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Payer maintenant', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}