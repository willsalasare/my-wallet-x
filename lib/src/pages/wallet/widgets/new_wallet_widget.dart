import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mywallet/src/core/wallet_repo.dart';

class NewWalletWidget extends StatefulWidget {
  const NewWalletWidget({Key? key}) : super(key: key);

  @override
  State<NewWalletWidget> createState() => _NewWalletWidgetState();
}

class _NewWalletWidgetState extends State<NewWalletWidget> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _walletController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _walletController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Wallet'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            controller: _amountController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            ],
            decoration: const InputDecoration(labelText: 'Saldo inicial'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: _shared, icon: const Icon(Icons.paste)),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Guardar'),
        )
      ],
    );
  }

  void _shared() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ingresa el ID de la wallet'),
        content: TextFormField(
          controller: _walletController,
          decoration: const InputDecoration(labelText: 'Wallet ID'),
        ),
        actions: [
          MaterialButton(
            onPressed: _add,
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }

  void _add() {
    WalletRepo.instance.importWallet(_walletController.text);
  }

  void _save() async {
    try {
      final amount = int.parse(_amountController.text);
      final user = FirebaseAuth.instance.currentUser;
      final data = {
        'name': _nameController.text,
        'amount': amount,
        'last_deposit': amount > 0 ? DateTime.now().toString() : null,
        'created_at': DateTime.now().toString(),
        'user_id': user?.uid
      };
      final res = await WalletRepo.instance.storeWallet(data);
      if (!mounted) return;
      Navigator.pop(context, res);
      Fluttertoast.showToast(msg: 'Wallet creada');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
