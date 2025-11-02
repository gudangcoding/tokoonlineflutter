import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/cart_event.dart';
import '../../component/app_text_input.dart';
import '../../component/app_select.dart';
import '../../component/app_snackbar.dart';
import '../../component/validators.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  String? _paymentMethod;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.status == CartStatus.success) {
              AppSnackbar.show(context, 'Pembayaran berhasil', type: SnackbarType.success);
              Navigator.of(context).pop();
            }
            if (state.status == CartStatus.error) {
              AppSnackbar.show(context, state.message ?? 'Pembayaran gagal', type: SnackbarType.error);
            }
          },
          builder: (context, state) {
            final loading = state.status == CartStatus.checkingOut;
            final paymentOptions = const ['Transfer Bank', 'Kartu Kredit', 'COD'];
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                const Text('Ringkasan'),
                const SizedBox(height: 8),
                ...state.items.map((i) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(i.product.name),
                      trailing: Text('x${i.qty}'),
                    )),
                const Divider(),
                Text('Total: Rp ${state.total.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 24),
                const Text('Alamat Pengiriman'),
                const SizedBox(height: 8),
                AppTextarea(
                  controller: _addressController,
                  label: 'Alamat',
                  hint: 'Alamat lengkap...',
                  validator: Validators.required('Alamat wajib diisi'),
                ),
                const SizedBox(height: 16),
                const Text('Metode Pembayaran'),
                const SizedBox(height: 8),
                AppSelect<String>(
                  value: _paymentMethod,
                  items: paymentOptions,
                  label: 'Metode Pembayaran',
                  itemLabel: (s) => s,
                  onChanged: (v) => setState(() => _paymentMethod = v),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () {
                          if (!_formKey.currentState!.validate()) return;
                          if (_paymentMethod == null) {
                            AppSnackbar.show(context, 'Pilih metode pembayaran terlebih dahulu', type: SnackbarType.error);
                            return;
                          }
                          final address = _addressController.text.trim();
                          final payment = _paymentMethod!;
                          context
                              .read<CartBloc>()
                              .add(CheckoutRequested(address: address, paymentMethod: payment));
                        },
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Bayar Sekarang'),
                ),
               ],
              ),
            );
          },
        ),
      ),
    );
  }
}