import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'XOF', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Charger le solde dès l'affichage de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final phone = Provider.of<AuthService>(context, listen: false).currentPhone;
      if (phone != null) {
        Provider.of<ApiService>(context, listen: false).fetchWalletBalance(phone);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: () async {
          if (authService.currentPhone != null) {
            await apiService.fetchWalletBalance(authService.currentPhone!);
          }
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            // Section Héro / Bannière avec le Solde (Inspirée de ton design)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF005C66), Color(0xFF007A87)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bonjour, ${authService.currentPhone ?? "Client"}',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.power_settings_new, color: Colors.white70),
                        onPressed: () async {
                          await authService.logout();
                          if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Solde disponible',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: apiService.isLoading
                            ? const Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                ),
                              )
                            : Text(
                                _isBalanceVisible
                                    ? _currencyFormat.format(apiService.balance)
                                    : '•••••••',
                                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() => _isBalanceVisible = !_isBalanceVisible);
                        },
                      ),
                    ],
                  ),
                  if (apiService.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      apiService.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),

            // Section Services / Raccourcis financiers (Calquée sur ton GridView)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Opérations Financières',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF005C66)),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _buildMenuCard(
                        context,
                        Icons.send_rounded,
                        'Transférer',
                        'Envoyer de l\'argent à un proche instantanément.',
                        '/transfer',
                      ),
                      _buildMenuCard(
                        context,
                        Icons.receipt_long_rounded,
                        'Payer Factures',
                        'Régler Senelec, Woyafal, ISM ou Rapido.',
                        '/bills',
                      ),
                      _buildMenuCard(
                        context,
                        Icons.history_rounded,
                        'Historique',
                        'Consulter l\'ensemble de vos transactions.',
                        '/history',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String title, String subtitle, String route) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A896).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: const Color(0xFF00A896)),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF005C66))),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade600, height: 1.2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}