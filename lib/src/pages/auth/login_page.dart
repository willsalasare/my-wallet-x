import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet/src/state/user_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff0c0c0f),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/logo.png',
            width: 60,
          ),
          const SizedBox(height: 10),
          const Text(
            'MyWalletX',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
              onPressed: login,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    child: Image.network(
                        'http://pngimg.com/uploads/google/google_PNG19635.png'),
                  ),
                  const Text('Iniciar con google'),
                ],
              ))
        ],
      ),
    );
  }

  void login() async {
    try {
      await context.read<UserState>().login();
      if (!mounted) return;
      context.push('/wallets');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
