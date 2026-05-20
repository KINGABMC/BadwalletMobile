import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
         
        Expanded(child: Center(child: Text('Espace Marketplace Étudiant'))),
      ],
    );
  }
}