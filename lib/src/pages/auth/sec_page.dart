import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mywallet/src/pages/auth/login_page.dart';
import 'package:mywallet/src/pages/wallet/wallets_page.dart';
import 'package:mywallet/src/state/user_state.dart';
import 'package:provider/provider.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _isAuth = false;
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    _isAuth = true;
    context.read<UserState>().setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return _isAuth ? const WalletsPage() : const LoginPage();
  }
}
