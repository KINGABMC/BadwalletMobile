import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/logements_screen.dart';
import 'screens/colocations_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart'; 

void main() {
  runApp(const CampusNetApp());
}

class CampusNetApp extends StatefulWidget {
  const CampusNetApp({super.key});

  @override
  State<CampusNetApp> createState() => _CampusNetAppState();
}

class _CampusNetAppState extends State<CampusNetApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusNet',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Poppins',
      ),
      home: MainNavigationPage(
        isDarkMode: _isDarkMode,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const MainNavigationPage({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 1;
  
  //  JUSTE CETTE VARIABLE AJOUTÉE
  bool _showBurgerMenu = false; 

  final List<Widget> _screens = [
    const HomeScreen(),
    const LogementsScreen(),
    const ColocationsScreen(),
    const MarketplaceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Text(
              'Campus',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0A3663),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const Text(
              'Net',
              style: TextStyle(
                color: Color(0xFF00A896),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
              color: isDark ? Colors.yellow : Colors.black87,
            ),
            onPressed: () {
              widget.onDarkModeChanged(!widget.isDarkMode);
            },
          ),
          //  MODIFICATION ICI : Au lieu d'ouvrir le endDrawer, on change l'état de notre variable
          IconButton(
            icon: Icon(
              _showBurgerMenu ? Icons.close : Icons.menu,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () {
              setState(() {
                _showBurgerMenu = !_showBurgerMenu;
              });
            },
          ),
        ],
      ),
      // ❌ endDrawer SUPPRIMÉ ICI
      
      //  MODIFICATION DU BODY : On empile le menu dropdown horizontal et l'écran actuel
      body: Column(
        children: [
          // Si le bouton burger est cliqué, on affiche le menu horizontal façon Dropdown
          if (_showBurgerMenu)
            Container(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _showBurgerMenu = false); // Ferme le menu dropdown
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF1E2533) : Colors.white,
                        side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Connexion',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _showBurgerMenu = false); // Ferme le menu dropdown
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                       },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A3663),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // L'écran de ton application prend le reste de l'espace disponible
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _showBurgerMenu = false; // Ferme automatiquement le menu au changement d'onglet
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white.withValues(alpha: 0.95),
          selectedItemColor: const Color(0xFF00A896),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment_outlined),
              activeIcon: Icon(Icons.apartment),
              label: 'Logements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Colocations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Marketplace',
            ),
          ],
        ),
      ),
    );
  }
}