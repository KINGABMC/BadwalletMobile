class TransactionModel {
  final String id;
  final String type; // 'DEPOSIT', 'WITHDRAW', 'TRANSFER_IN', 'TRANSFER_OUT'
  final double amount;
  final String? description;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? 'TRANSFER',
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}