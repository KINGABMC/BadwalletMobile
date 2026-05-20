import 'package:flutter/material.dart';
import 'package:campusnet_mobile/widgets/advanced_filter_panel.dart';
import 'details_screen.dart';

class LogementsScreen extends StatefulWidget {
  const LogementsScreen({super.key});

  @override
  State<LogementsScreen> createState() => _LogementsScreenState();
}

class _LogementsScreenState extends State<LogementsScreen> {
  bool _showFilters = true;
  double _currentMaxPrice = 500000;
  String _currentRooms = 'Toutes';
  String _currentNeighborhood = 'Tout';


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Row(
            children: [
              const Text('🏠 ', style: TextStyle(fontSize: 24)),
              Text(
                'Logements disponibles',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Logements libérés par des étudiants en fin de cursus.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),

        // Barre de Recherche & Bouton
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher par quartier ou titre...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => setState(() => _showFilters = !_showFilters),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3663),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Filtres'),
              ),
            ],
          ),
        ),

        // Appel de notre fonction unique de filtrage
        if (_showFilters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AdvancedFilterPanel(
              maxPrice: _currentMaxPrice,
              selectedRooms: _currentRooms,
              selectedNeighborhood: _currentNeighborhood,
              onPriceChanged: (val) => setState(() => _currentMaxPrice = val),
              onRoomsChanged: (val) => setState(() => _currentRooms = val!),
              onNeighborhoodChanged: (val) => setState(() => _currentNeighborhood = val!),
            ),
          ),

        const SizedBox(height: 16),

        // Carte Produit cliquable
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailsScreen(
                  title: 'Chambre meublée Liberté 6',
                  category: 'Logement',
                  price: '150,000 F CFA / mois',
                  image: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=1000',
                  description: 'Magnifique chambre entièrement équipée dans un secteur calme et recherché de Liberté 6. Idéal pour les étudiants studieux recherchant le confort et la proximité des transports.',
                ),
              ),
            );
          },
          child: _buildItemCard(
            'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=1000',
            'Logement',
            'Chambre meublée Liberté 6',
            '150,000 F CFA / mois',
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(String imageUrl, String tag, String title, String price) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.transparent),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFF0A3663), borderRadius: BorderRadius.circular(20)),
                    child: Text(tag, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(price, style: const TextStyle(fontSize: 16, color: Color(0xFF0A3663), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}