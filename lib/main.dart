import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet/src/models/wallet_model.dart';
import 'package:mywallet/src/pages/auth/login_page.dart';
import 'package:mywallet/src/pages/auth/sec_page.dart';
import 'package:mywallet/src/pages/transactions/transactions_page.dart';
import 'package:mywallet/src/pages/wallet/wallets_page.dart';
import 'package:mywallet/src/state/user_state.dart';
import 'package:mywallet/src/state/wallet_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SecurityPage(),
        ),
        GoRoute(
          path: '/wallets',
          builder: (context, state) => const WalletsPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) =>
              TransactionsPage(wallet: state.extra as Wallet),
        ),
      ],
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletState>(create: (_) => WalletState()),
        ChangeNotifierProvider<UserState>(create: (_) => UserState()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
      ),
    );
  }
}
