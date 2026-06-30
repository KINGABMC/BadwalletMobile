import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../models/transaction_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'XOF', decimalDigits: 0);
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final phone = Provider.of<AuthService>(context, listen: false).currentPhone;
      if (phone != null) {
        Provider.of<ApiService>(context, listen: false).fetchTransactions(phone);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Historique des activités', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF005C66),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (authService.currentPhone != null) {
            await apiService.fetchTransactions(authService.currentPhone!);
          }
        },
        child: apiService.isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF00A896)))
            : apiService.errorMessage != null
                ? Center(child: Text(apiService.errorMessage!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)))
                : apiService.transactions.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('Aucune transaction enregistrée', style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16.0),
                        itemCount: apiService.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = apiService.transactions[index];
                          
                          // Détermination du code couleur et du signe (+ / -) selon le type de transaction
                          final bool isIncome = tx.type == 'DEPOSIT' || tx.type == 'TRANSFER_IN';
                          final Color typeColor = isIncome ? const Color(0xFF00A896) : Colors.redAccent;
                          final String prefix = isIncome ? '+ ' : '- ';

                          // Libellé propre pour l'affichage de l'opération
                          String displayTitle = 'Transaction';
                          if (tx.type == 'DEPOSIT') displayTitle = 'Dépôt reçu';
                          if (tx.type == 'WITHDRAW') displayTitle = 'Retrait effectué';
                          if (tx.type == 'TRANSFER_IN') displayTitle = 'Transfert reçu';
                          if (tx.type == 'TRANSFER_OUT') displayTitle = 'Transfert envoyé';

                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: typeColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                  color: typeColor,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                displayTitle,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005C66), fontSize: 15),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tx.description != null && tx.description!.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(tx.description!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                  ],
                                  const SizedBox(height: 4),
                                  Text(
                                    _dateFormat.format(tx.createdAt),
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                '$prefix${_currencyFormat.format(tx.amount)}',
                                style: TextStyle(color: typeColor, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}