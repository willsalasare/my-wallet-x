import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mywallet/src/core/wallet_repo.dart';
import 'package:mywallet/src/models/category.dart';

class NewTransactionWidget extends StatefulWidget {
  const NewTransactionWidget({Key? key, required this.walletId})
      : super(key: key);
  final String walletId;

  @override
  State<NewTransactionWidget> createState() => _NewTransactionWidgetState();
}

class _NewTransactionWidgetState extends State<NewTransactionWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late bool _isAdd = true;
  Category? _category;
  late Category _cData;
  bool _loading = true;
  final List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _getCategories();
  }

  void _getCategories() async {
    final res = await WalletRepo.instance.categories();
    _categories.addAll(res);
    setState(() {});
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva transacción'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    validator: (s) {
                      if (s == null || s.isEmpty) {
                        return 'Agrega un monto';
                      }
                      return null;
                    },
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
              validator: (s) {
                if (s == null || s.isEmpty) {
                  return 'Agrega una nota';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: 'Nota'),
            ),
            _loading
                ? const SizedBox.shrink()
                : DropdownButtonFormField<Category>(
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    value: _category,
                    items: _categories
                        .map((e) => DropdownMenuItem<Category>(
                              onTap: () => _cData = e,
                              value: e,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/${e.path}',
                                    width: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(e.title),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (s) => setState(() {
                          _category = s;
                        })),
          ],
        ),
      ),
      actions: [ElevatedButton(onPressed: _save, child: const Text('Guardar'))],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final data = {
        'amount': int.parse(_amountController.text),
        'note': _notesController.text,
        'created_at': DateTime.now().toString(),
        'type': _isAdd ? 1 : 0,
        'wallet_id': widget.walletId,
        'category': _cData.toJson(),
      };
      final res = await WalletRepo.instance.storeTransaction(data);
      if (!mounted) return;
      Navigator.pop(context, res);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }
}
