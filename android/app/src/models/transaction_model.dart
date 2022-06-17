class Transaction {
  late String id, walletId, notes, createdAt;
  late int amount, type;
  Transaction({
    required this.id,
    required this.walletId,
    required this.notes,
    required this.createdAt,
    required this.amount,
    required this.type,
  });
  factory Transaction.fromJson(Map json) => Transaction(
        id: json['id'],
        amount: json['amount'],
        walletId: json['wallet_id'],
        notes: json['notes'],
        createdAt: json['created_at'],
        type: json['type'],
      );

  Map<String, dynamic> toSave() => {
        'wallet_id': walletId,
        'notes': notes,
        'created_at': createdAt,
        'amount': amount,
        'type': type
      };
}
