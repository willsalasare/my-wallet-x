import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mywallet/src/core/wallet_repo.dart';
import 'package:mywallet/src/models/wallet_model.dart';

class WalletState extends ChangeNotifier {
  bool loading = true;
  final List<Wallet> wallets = [];

  void add(Wallet wallet) {
    wallets.add(wallet);
    notifyListeners();
  }

  void getWallets() async {
    try {
      wallets.clear();
      final res = await WalletRepo.instance.wallets();
      wallets.addAll(res);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void updateWallet(Wallet wallet) {
    wallets.firstWhere((w) => w.id == wallet.id) == wallet;
    notifyListeners();
  }

  Future<void> deleteWallet(Wallet wallet) async {
    await WalletRepo.instance.deleteWallet(wallet);
    wallets.removeWhere((e) => e.id == wallet.id);
    notifyListeners();
  }
}
