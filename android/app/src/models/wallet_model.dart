class Wallet {
  late int amount;
  late String id, name, createdAt;
  String? lastDeposit;
  Wallet(
      {required this.id,
      this.amount = 0,
      required this.name,
      required this.createdAt,
      this.lastDeposit});

  factory Wallet.fromJson(Map json) => Wallet(
        id: json['id'],
        name: json['name'],
        amount: json['amount'] ?? 0,
        createdAt: json['created_at'],
        lastDeposit: json['last_deposit'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'created_at': createdAt,
        'last_deposit': lastDeposit,
      };
}
