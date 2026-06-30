import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';

import 'screens/auth/login_screen.dart';
import 'screens/dashboard/home_screen.dart';
import 'screens/transfers/transfer_screen.dart';
import 'screens/bills/bills_screen.dart';
import 'screens/history/history_screen.dart';

void main() async {
  // Initialiser le formatage des dates en français pour l'historique
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ApiService()),
      ],
      child: const BadWalletApp(),
    ),
  );
}

class BadWalletApp extends StatelessWidget {
  const BadWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BadWallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Point de départ : Écran de Login
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/transfer': (context) => const TransferScreen(),
        '/bills': (context) => const BillsScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}