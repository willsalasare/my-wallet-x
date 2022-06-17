import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mywallet/src/services/auth_service.dart';

class UserState extends ChangeNotifier {
  User? user;
  Future<void> login() async {
    final res = await AuthService.instance.signInWithGoogle();
    user = res.user;
    notifyListeners();
  }

  void setUser(User user) {
    this.user = user;
  }
}
