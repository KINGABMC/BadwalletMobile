class WalletModel {
  final String id;
  final String phoneNumber;
  final double balance;

  WalletModel({
    required this.id,
    required this.phoneNumber,
    required this.balance,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id']?.toString() ?? '',
      phoneNumber: json['phoneNumber'] ?? json['customer'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}