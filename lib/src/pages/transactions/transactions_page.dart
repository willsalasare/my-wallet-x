import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mywallet/src/core/wallet_repo.dart';
import 'package:mywallet/src/models/transaction_model.dart';
import 'package:mywallet/src/models/wallet_model.dart';
import 'package:mywallet/src/pages/transactions/widgets/new_transaction_widget.dart';
import 'package:mywallet/src/state/wallet_state.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key, required this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final List<Transaction> _list = [];
  late bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getTransactions();
  }

  void _getTransactions() async {
    final res = await WalletRepo.instance.transactions();
    _list.addAll(res);
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wallet.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _new,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? _loadingWidget
          : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (_, i) {
                final isAdd = _list[i].type == 1 ? true : false;
                final s = isAdd ? '+' : '-';
                final title = '$s \$${_list[i].amount}';
                final item = _list[i];
                return Card(
                  child: InkWell(
                    onTap: () => _showMemu(item),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                      'assets/icons/${item.category['path']}',
                                      width: 20),
                                  const SizedBox(width: 5),
                                  Text(item.category['title']!),
                                ],
                              ),
                              const Spacer(),
                              Text(title,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color:
                                          isAdd ? Colors.green : Colors.red)),
                            ],
                          ),
                          Text(item.note ?? ''),
                          Text(item.createdAt.substring(0, 10)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }

  Widget get _loadingWidget => const Center(child: CircularProgressIndicator());

  void _showMemu(Transaction transaction) {
    showModalBottomSheet(
        context: context,
        builder: (_) => ListView(
              shrinkWrap: true,
              children: [
                // ListTile(
                //   leading: const Icon(
                //     Icons.edit,
                //     color: Colors.blue,
                //   ),
                //   title: const Text('Editar'),
                //   onTap: () {},
                // ),
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text('Eliminar'),
                  onTap: () => _delete(transaction),
                )
              ],
            ));
  }

  void _delete(Transaction transaction) {
    WalletRepo.instance.deleteTransaction(transaction);
    _list.removeWhere((element) => element.id == transaction.id);
    widget.wallet.amount = transaction.type == 1
        ? widget.wallet.amount - transaction.amount
        : widget.wallet.amount + transaction.amount;
    context.read<WalletState>().updateWallet(widget.wallet);
    setState(() {});
    Navigator.pop(context);
    Fluttertoast.showToast(msg: 'Eliminado');
  }

  void _new() async {
    final res = await showDialog<Transaction>(
        context: context,
        builder: (_) => NewTransactionWidget(
              walletId: widget.wallet.id,
            ));
    if (res != null) {
      _list.add(res);
      widget.wallet.amount = res.type == 1
          ? widget.wallet.amount + res.amount
          : widget.wallet.amount - res.amount;
      if (mounted) {
        context.read<WalletState>().updateWallet(widget.wallet);
      }
      setState(() {});
    }
  }
}
