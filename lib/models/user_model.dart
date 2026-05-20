enum UserRole { etudiant, proprietaire, admin }

enum StatutVerification { enAttente, valide, rejete }

class UserModel {
  final String id;
  final String nomComplet;
  final String email;
  final String? telephone;
  final String? universite;
  final String? photoProfilUrl;
  final UserRole role;
  final StatutVerification statutVerification;
  final bool estActif;
  final DateTime dateInscription;

  UserModel({
    required this.id,
    required this.nomComplet,
    required this.email,
    this.telephone,
    this.universite,
    this.photoProfilUrl,
    required this.role,
    required this.statutVerification,
    required this.estActif,
    required this.dateInscription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nomComplet: json['nomComplet'],
      email: json['email'],
      telephone: json['telephone'],
      universite: json['universite'],
      photoProfilUrl: json['photoProfilUrl'],
      role: UserRole.values.firstWhere(
            (r) => r.name == json['role'],
        orElse: () => UserRole.etudiant,
      ),
      statutVerification: StatutVerification.values.firstWhere(
            (s) => s.name == json['statutVerification'],
        orElse: () => StatutVerification.enAttente,
      ),
      estActif: json['estActif'] ?? true,
      dateInscription: DateTime.parse(json['dateInscription']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nomComplet': nomComplet,
    'email': email,
    'telephone': telephone,
    'universite': universite,
    'photoProfilUrl': photoProfilUrl,
    'role': role.name,
    'statutVerification': statutVerification.name,
    'estActif': estActif,
    'dateInscription': dateInscription.toIso8601String(),
  };
}