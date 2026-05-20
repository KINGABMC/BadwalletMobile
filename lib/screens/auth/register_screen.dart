import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_widgets.dart';

const List<String> kUniversites = [
  'UCAD - Université Cheikh Anta Diop',
  'ISM - Institut Supérieur de Management',
  'ESP - École Supérieure Polytechnique',
  'UCAO - Université Catholique de l\'Afrique de l\'Ouest',
  'ISI - Institut Supérieur Informatique ',
  'Autre',
];

const List<String> kAnnees = [
  'Licence 1 (L1)',
  'Licence 2 (L2)',
  'Licence 3 (L3)',
  'Master 1 (M1)',
  'Master 2 (M2)',
  'Doctorat',
  'Autre',
];

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ── Étape courante (0 = infos perso, 1 = infos académiques) ──────────────
  int _currentStep = 0;

  // ── Étape 1 ───────────────────────────────────────────────────────────────
  final _step1Key = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // ── Étape 2 ───────────────────────────────────────────────────────────────
  final _step2Key = GlobalKey<FormState>();
  final _filiereController = TextEditingController();
  String? _selectedUniversite;
  String? _selectedAnnee;

  bool _isLoading = false;
  String? _errorMessage;

  final _authService = AuthService();

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _filiereController.dispose();
    super.dispose();
  }

  // ── Valider étape 1 et passer à l'étape 2 ────────────────────────────────
  void _goToStep2() {
    if (!_step1Key.currentState!.validate()) return;
    setState(() {
      _currentStep = 1;
      _errorMessage = null;
    });
  }

  // ── Soumettre le formulaire complet ──────────────────────────────────────
  Future<void> _handleRegister() async {
    if (!_step2Key.currentState!.validate()) return;

    if (_selectedUniversite == null) {
      setState(() => _errorMessage = 'Choisis ton université.');
      return;
    }
    if (_selectedAnnee == null) {
      setState(() => _errorMessage = 'Choisis ton année d\'étude.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.register(
      nomComplet: _nomController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      telephone: _phoneController.text.trim(),
      universite: _selectedUniversite!,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      // TODO : Navigator vers écran de vérification carte étudiant
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Compte créé ! Bienvenue ${result.user!.nomComplet} 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() => _errorMessage = result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CampusColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // ── Logo ──
              const CampusNetLogo(fontSize: 28),
              const SizedBox(height: 28),

              // ── Titre ──
              const Text(
                'Rejoins CampusNet ',
                style: TextStyle(
                  color: CampusColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Crée ton compte étudiant',
                style: TextStyle(
                  color: CampusColors.textSecondary,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // ── Stepper ──
              CampusStepper(currentStep: _currentStep),
              const SizedBox(height: 28),

              // ── Carte formulaire ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CampusColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _currentStep == 0 ? _buildStep1() : _buildStep2(),
              ),
              const SizedBox(height: 28),

              // ── Lien connexion ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Déjà un compte ? ',
                    style: TextStyle(
                        color: CampusColors.textSecondary, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        color: CampusColors.teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── ÉTAPE 1 : Infos personnelles ──────────────────────────────────────────
  Widget _buildStep1() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null) ...[
            ErrorBanner(message: _errorMessage!),
            const SizedBox(height: 16),
          ],

          CampusTextField(
            controller: _nomController,
            label: 'Nom complet',
            hint: 'Amadou Diallo',
            prefixIcon: Icons.person_outline,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Champ obligatoire';
              if (val.trim().length < 3) return 'Nom trop court';
              return null;
            },
          ),
          const SizedBox(height: 20),

          CampusTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'ton.email@ucad.edu.sn',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Champ obligatoire';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          CampusTextField(
            controller: _phoneController,
            label: 'Téléphone',
            hint: '+221 77 123 45 67',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          const SizedBox(height: 20),

          CampusTextField(
            controller: _passwordController,
            label: 'Mot de passe',
            hint: 'Min. 6 caractères',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            suffixWidget: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: CampusColors.textSecondary,
                size: 18,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Champ obligatoire';
              if (val.length < 6) return '6 caractères minimum';
              return null;
            },
          ),
          const SizedBox(height: 24),

          // ── Bouton Continuer ──
          CampusPrimaryButton(
            label: 'Continuer',
            onPressed: _goToStep2,
          ),
        ],
      ),
    );
  }

  // ── ÉTAPE 2 : Infos académiques ───────────────────────────────────────────
  Widget _buildStep2() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null) ...[
            ErrorBanner(message: _errorMessage!),
            const SizedBox(height: 16),
          ],

          CampusDropdown(
            label: 'Université',
            hint: 'Choisis ton université',
            value: _selectedUniversite,
            items: kUniversites,
            onChanged: (val) => setState(() => _selectedUniversite = val),
          ),
          const SizedBox(height: 20),

          CampusTextField(
            controller: _filiereController,
            label: 'Filière',
            hint: 'Ex: Informatique, Droit, Médecine...',
            prefixIcon: Icons.school_outlined,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Champ obligatoire';
              return null;
            },
          ),
          const SizedBox(height: 20),

          CampusDropdown(
            label: "Année d'étude",
            hint: 'Choisis ton année',
            value: _selectedAnnee,
            items: kAnnees,
            onChanged: (val) => setState(() => _selectedAnnee = val),
          ),
          const SizedBox(height: 24),

          // ── Boutons Retour + Créer mon compte ──
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CampusSecondaryButton(
                  label: 'Retour',
                  onPressed: () => setState(() {
                    _currentStep = 0;
                    _errorMessage = null;
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: CampusPrimaryButton(
                  label: 'Créer mon compte',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                  showArrow: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
