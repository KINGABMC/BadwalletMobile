import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final bool isVisible;
  final bool isLoading;
  final VoidCallback onToggleVisibility;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.isVisible,
    required this.isLoading,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'XOF', decimalDigits: 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF005C66), Color(0xFF007A87)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005C66).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Solde disponible',
            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoading
                  ? const SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      isVisible ? currencyFormat.format(balance) : '•••••••',
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
              IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: onToggleVisibility,
              ),
            ],
          ),
        ],
      ),
    );
  }
}