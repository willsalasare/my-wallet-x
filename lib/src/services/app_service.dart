import 'package:mywallet/src/core/wallet_repo.dart';

class AppService {
  AppService._();
  static final _instance = AppService._();
  AppService get instance => _instance;

  static Future<void> initialize() async {
    await WalletRepo.instance.setCategories();
  }
}
