import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mywallet/src/models/transaction_model.dart' as t;
import 'package:mywallet/src/models/wallet_model.dart';

class WalletRepo {
  WalletRepo._();
  static final _instance = WalletRepo._();
  static final instance = _instance;
  final _db = FirebaseFirestore.instance;

  Future<Wallet> storeWallet(Map<String, dynamic> data) async {
    final res = await _db.collection('wallets').add(data);
    return Wallet.fromJson({
      ...data,
      'id': res.id,
    });
  }

  Future<List<Wallet>> wallets() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final res = await _db
        .collection('wallets')
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at')
        .get();
    final invitedWallets = await _getWallets(userId!);

    final List<Wallet> d = [];
    d.addAll(invitedWallets);
    for (final x in res.docs) {
      d.add(Wallet.fromJson({...x.data(), 'id': x.id}));
    }
    return d;
  }

  Future<List<Wallet>> _getWallets(String uid) async {
    final walletRes = (await _db
        .collection('user_wallets')
        .where('user_id', isEqualTo: uid)
        .get());
    if (walletRes.docs.isEmpty) return [];
    final walletIds = walletRes.docs.map((e) => e['wallet_id']).toList();
    final walletsRes = await _db
        .collection('wallets')
        .where('__name__', whereIn: walletIds)
        .get();
    final List<Wallet> d = [];
    for (final x in walletsRes.docs) {
      d.add(Wallet.fromJson({...x.data(), 'id': x.id}));
    }
    return d;
  }

  Future<List<t.Transaction>> transactions() async {
    final res =
        await _db.collection('transactions').orderBy('created_at').get();
    final List<t.Transaction> d = [];
    for (final x in res.docs) {
      d.add(t.Transaction.fromJson({'id': x.id, ...x.data()}));
    }
    return d;
  }

  Future<t.Transaction> storeTransaction(Map<String, dynamic> data) async {
    final res = await _db.collection('transactions').add(data);
    final wallet = _db.collection('wallets').doc(data['wallet_id']);
    final gAmount = (await wallet.get()).data()?['amount'] ?? 0;
    final fA =
        data['type'] == 1 ? gAmount + data['amount'] : gAmount - data['amount'];
    await wallet.update({'amount': fA});
    return t.Transaction.fromJson({'id': res.id, ...data});
  }

  Future<void> deleteTransaction(t.Transaction transaction) async {
    await _db.collection('transactions').doc(transaction.id).delete();
    final wallet = _db.collection('wallets').doc(transaction.walletId);
    final gAmount = (await wallet.get()).data()?['amount'];
    final fA = transaction.type == 1
        ? gAmount - transaction.amount
        : gAmount + transaction.amount;
    wallet.update({'amount': fA});
  }

  Future<void> deleteWallet(Wallet wallet) async {
    await _db.collection('wallets').doc(wallet.id).delete();
    final transactions = await _db
        .collection('transactions')
        .where('wallet_id', isEqualTo: wallet.id)
        .get();
    for (final t in transactions.docs) {
      t.reference.delete();
    }
  }

  Future<Wallet> importWallet(String id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await _db
        .collection('user_wallets')
        .add({'user_id': userId, 'wallet_id': id});
    final wallet = await _db.collection('wallets').doc(id).get();
    return Wallet.fromJson({...?wallet.data(), 'id': wallet.id});
  }
}
