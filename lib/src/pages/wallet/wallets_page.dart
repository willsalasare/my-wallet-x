import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet/src/models/wallet_model.dart';
import 'package:mywallet/src/pages/wallet/widgets/new_wallet_widget.dart';
import 'package:mywallet/src/state/user_state.dart';
import 'package:mywallet/src/state/wallet_state.dart';
import 'package:mywallet/src/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({Key? key}) : super(key: key);

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  bool _deleting = false;
  @override
  void initState() {
    super.initState();
    context.read<WalletState>().getWallets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets'),
      ),
      drawer: const DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: _newWallet,
        child: const Icon(Icons.add),
      ),
      body: Consumer<WalletState>(
        builder: (context, value, child) => value.loading
            ? _loadingWidget
            : ListView.builder(
                shrinkWrap: true,
                itemCount: value.wallets.length,
                itemBuilder: (_, i) => _card(value.wallets[i]),
              ),
      ),
    );
  }

  Widget get _loadingWidget => const Center(child: CircularProgressIndicator());

  Widget _card(Wallet wallet) => Card(
        child: InkWell(
          onTap: () => context.push('/transactions', extra: wallet),
          onLongPress: () => _menu(wallet),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '\$${wallet.amount}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                Text(wallet.name)
              ],
            ),
          ),
        ),
      );

  void _newWallet() async {
    final res = await showDialog<Wallet>(
      context: context,
      builder: (_) => const NewWalletWidget(),
    );
    if (res != null) {
      if (mounted) {
        context.read<WalletState>().add(res);
      }
    }
  }

  void _menu(Wallet wallet) {
    final user = context.read<UserState>().user;
    if (user?.uid != wallet.userId) return;

    showModalBottomSheet(
        context: context,
        builder: (_) => ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Compartir'),
                  onTap: () => _share(wallet),
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Eliminar'),
                  onTap: () => _delete(wallet),
                ),
              ],
            ));
  }

  void _share(Wallet wallet) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: const Text('Comparte este ID'),
            content: Row(
              children: [
                Text(wallet.id),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: wallet.id));
                      Fluttertoast.showToast(
                          msg: 'Copiado', backgroundColor: Colors.green);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.copy))
              ],
            )));
  }

  void _delete(Wallet wallet) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('¿Estas seguro que quieres eliminar ${wallet.name}?'),
              actions: [
                MaterialButton(
                  color: Colors.red,
                  onPressed: () async {
                    if (_deleting) return;
                    setState(() {
                      _deleting = true;
                    });
                    await context.read<WalletState>().deleteWallet(wallet);
                    if (!mounted) return;
                    setState(() {
                      _deleting = false;
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: _deleting
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : const Text(
                          'Si, eliminar',
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ));
  }
}
