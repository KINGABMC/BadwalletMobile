import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AuthService {
  // ⚠️ Remplace par l'IP de ta machine (pas localhost sur émulateur Android)
  // Émulateur Android  → 10.0.2.2
  // Appareil réel      → IP locale ex: 192.168.1.X
  static const String _baseUrl = 'https://10.0.2.2:8443/api';
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'current_user';

  // ── Client HTTP qui accepte les certificats auto-signés (DEV uniquement) ──
  http.Client _createClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; // ⚠️ DEV only
    return IOClient(httpClient);
  }

  // ── Connexion Email / Mot de passe ────────────────────────────────────────
  Future<AuthResult> login(String email, String password) async {
    try {
      final client = _createClient();
      final response = await client.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'motDePasse': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = UserModel.fromJson(data['user']);
        await _saveSession(token, user);
        return AuthResult.success(user: user, token: token);
      } else if (response.statusCode == 401) {
        return AuthResult.failure('Email ou mot de passe incorrect.');
      } else {
        return AuthResult.failure('Erreur serveur. Réessaie plus tard.');
      }
    } catch (e) {
      return AuthResult.failure('Impossible de joindre le serveur. Vérifie ta connexion.');
    }
  }

  // ── Inscription ───────────────────────────────────────────────────────────
  Future<AuthResult> register({
    required String nomComplet,
    required String email,
    required String password,
    required String telephone,
    required String universite,
  }) async {
    try {
      final client = _createClient();
      final response = await client.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nomComplet': nomComplet,
          'email': email,
          'motDePasse': password,
          'telephone': telephone,
          'universite': universite,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = UserModel.fromJson(data['user']);
        await _saveSession(token, user);
        return AuthResult.success(user: user, token: token);
      } else if (response.statusCode == 409) {
        return AuthResult.failure('Cet email est déjà utilisé.');
      } else {
        return AuthResult.failure('Erreur lors de l\'inscription.');
      }
    } catch (e) {
      return AuthResult.failure('Impossible de joindre le serveur.');
    }
  }

  // ── Connexion Google OAuth2 ───────────────────────────────────────────────
  Future<AuthResult> loginWithGoogle(String googleIdToken) async {
    try {
      final client = _createClient();
      final response = await client.post(
        Uri.parse('$_baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': googleIdToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = UserModel.fromJson(data['user']);
        await _saveSession(token, user);
        return AuthResult.success(user: user, token: token);
      } else {
        return AuthResult.failure('Connexion Google échouée.');
      }
    } catch (e) {
      return AuthResult.failure('Impossible de joindre le serveur.');
    }
  }

  // ── Déconnexion ───────────────────────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // ── Vérifier session ──────────────────────────────────────────────────────
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  // ── Sauvegarde session locale ─────────────────────────────────────────────
  Future<void> _saveSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}

// ── Classe résultat ───────────────────────────────────────────────────────────
class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? token;
  final String? errorMessage;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.token,
    this.errorMessage,
  });

  factory AuthResult.success({required UserModel user, required String token}) {
    return AuthResult._(isSuccess: true, user: user, token: token);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(isSuccess: false, errorMessage: message);
  }
}