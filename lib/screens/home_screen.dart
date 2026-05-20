import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        // Section Héro / Bannière
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005C66), Color(0xFF007A87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trouvez votre logement étudiant à Dakar',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'La plateforme communautaire pour les étudiants de l\'UCAD et des autres universités.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A896),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Explorer les offres', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        // Section Catégories / Raccourcis
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nos Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0A3663)),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildServiceCard(context, Icons.apartment, 'Logements disponibles', 'Les étudiants signalent les logements qu\'ils quittent avec photos, localisation et détails.'),
                  _buildServiceCard(context, Icons.people, 'Colocations', 'Propose ou cherche une colocation. Trouve des colocataires compatibles.'),
                  _buildServiceCard(context, Icons.shopping_bag, 'Marketplace mobilier', 'Achète et vends du mobilier d\'occasion entre étudiants. Paiement Wave & OM.'),
                  _buildServiceCard(context, Icons.forum, 'Contact Direct', 'Contacte les annonceurs via WhatsApp ou appel directement depuis l\'app.'),
                  _buildServiceCard(context, Icons.location_on, 'Profil', 'Modifie ou cree votre profil.'),
                  _buildServiceCard(context, Icons.settings, 'Paramètres', 'Modifiez votre paramètres de notification et de privacité.'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF00A896)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}