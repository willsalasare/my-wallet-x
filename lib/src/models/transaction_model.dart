import 'package:mywallet/src/models/category.dart';

class Transaction {
  late String id, walletId, note, createdAt;
  late int amount, type;
  Category category;
  Transaction({
    required this.id,
    required this.walletId,
    required this.note,
    required this.createdAt,
    required this.amount,
    required this.type,
    required this.category,
  });
  factory Transaction.fromJson(Map json) => Transaction(
        id: json['id'],
        amount: json['amount'],
        walletId: json['wallet_id'],
        note: json['note'],
        createdAt: json['created_at'],
        type: json['type'],
        category: Category.fromJson(json['category']),
      );

  Map<String, dynamic> toSave() => {
        'wallet_id': walletId,
        'note': note,
        'created_at': createdAt,
        'amount': amount,
        'type': type,
        'category': category
      };
}
