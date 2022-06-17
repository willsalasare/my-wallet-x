import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mywallet/src/core/wallet_repo.dart';

class NewTransactionWidget extends StatefulWidget {
  const NewTransactionWidget({Key? key, required this.walletId})
      : super(key: key);
  final String walletId;

  @override
  State<NewTransactionWidget> createState() => _NewTransactionWidgetState();
}

class _NewTransactionWidgetState extends State<NewTransactionWidget> {
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late bool _isAdd = true;
  String _category = 'Ropa';
  late Map<String, String> _cData;
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva transacción'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ],
                ),
              ),
              Switch(
                  activeColor: Colors.greenAccent.shade400,
                  inactiveThumbColor: Colors.red,
                  value: _isAdd,
                  onChanged: (v) {
                    _isAdd = v;
                    setState(() {});
                  }),
            ],
          ),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Nota'),
          ),
          DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Categoria'),
              value: _category,
              items: _items
                  .map((e) => DropdownMenuItem(
                        onTap: () => _cData = e,
                        value: e['title'],
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/${e['path']}',
                              width: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(e['title']!),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (s) => setState(() {
                    _category = s!;
                  })),
        ],
      ),
      actions: [ElevatedButton(onPressed: _save, child: const Text('Guardar'))],
    );
  }

  static const List<Map<String, String>> _items = [
    {'title': 'Regalos', 'path': 'giftbox.png'},
    {'title': 'Tienda', 'path': 'store.png'},
    {'title': 'Ropa', 'path': 'ropa.png'},
    {'title': 'Comida', 'path': 'food.png'},
    {'title': 'Transporte', 'path': 'transport.png'},
    {'title': 'Salud', 'path': 'salud.png'},
    {'title': 'Mascotas', 'path': 'mascotas.png'},
    {'title': 'Gym', 'path': 'gym.png'},
    {'title': 'Finanzas', 'path': 'finanzas.png'},
    {'title': 'Eduación', 'path': 'studying.png'},
    {'title': 'Familia', 'path': 'family.png'},
    {'title': 'Casa', 'path': 'home.png'},
  ];

  void _save() async {
    try {
      final data = {
        'amount': int.parse(_amountController.text),
        'note': _notesController.text,
        'created_at': DateTime.now().toString(),
        'type': _isAdd ? 1 : 0,
        'wallet_id': widget.walletId,
        'category': _cData,
      };
      final res = await WalletRepo.instance.storeTransaction(data);
      if (!mounted) return;
      Navigator.pop(context, res);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }
}
