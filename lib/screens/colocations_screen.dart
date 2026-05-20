import 'package:flutter/material.dart';
import 'package:campusnet_mobile/widgets/advanced_filter_panel.dart';
import 'details_screen.dart';

class ColocationsScreen extends StatefulWidget {
  const ColocationsScreen({super.key});

  @override
  State<ColocationsScreen> createState() => _ColocationsScreenState();
}

class _ColocationsScreenState extends State<ColocationsScreen> {
  // 1. On déclare les variables d'état spécifiques à l'écran Colocation
  bool _showFilters = false;
  double _colocMaxPrice = 300000;
  String _colocRooms = 'Toutes';
  String _colocNeighborhood = 'Tout';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        // Recherche principale
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
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher par quartier...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => setState(() => _showFilters = !_showFilters),
                style: IconButton.styleFrom(
                  side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),

        // 2. ICI : On appelle le filtre de logements_screen en lui injectant nos variables !
        if (_showFilters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                // On appelle le composant extrait avec ses paramètres
                child: AdvancedFilterPanel(
                  maxPrice: _colocMaxPrice,
                  selectedRooms: _colocRooms,
                  selectedNeighborhood: _colocNeighborhood,
                  onPriceChanged: (val) => setState(() => _colocMaxPrice = val),
                  onRoomsChanged: (val) => setState(() => _colocRooms = val!),
                  onNeighborhoodChanged: (val) => setState(() => _colocNeighborhood = val!),
                ),
              ),
            ),
          ),

        // Carte Colocation cliquable vers les détails
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailsScreen(
                  title: 'Chambre moderne - Liberté 6',
                  category: 'Colocation',
                  price: '85,000 F CFA / mois',
                  image: 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?q=80&w=1000',
                  description: 'Grande chambre lumineuse disponible dans un appartement en colocation de 3 étudiants. Salon commun équipé, cuisine et connexion Wi-Fi haut débit incluse.',
                ),
              ),
            );
          },
          child: _buildItemCard(
            'https://images.unsplash.com/photo-1505691938895-1758d7feb511?q=80&w=1000',
            'Colocation',
            'Chambre moderne - Liberté 6',
            '85,000 F CFA / mois',
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(
    String imageUrl,
    String tag,
    String title,
    String price,
  ) {
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
                Image.network(
                  imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A3663),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0A3663),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}