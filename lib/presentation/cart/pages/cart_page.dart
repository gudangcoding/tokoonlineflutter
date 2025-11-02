import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/cart_event.dart';
import '../../component/app_snackbar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.success) {
            AppSnackbar.show(context, 'Checkout berhasil', type: SnackbarType.success);
          }
          if (state.status == CartStatus.error) {
            AppSnackbar.show(context, state.message ?? 'Checkout gagal', type: SnackbarType.error);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(item.product.name),
                      subtitle: Text('Qty: ${item.qty}'),
                      trailing: Text('Rp ${(item.product.price * item.qty).toStringAsFixed(0)}'),
                      onLongPress: () => context.read<CartBloc>().add(RemoveFromCart(item.product.id)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(child: Text('Total: Rp ${state.total.toStringAsFixed(0)}')),
                    ElevatedButton(
                      onPressed: state.items.isEmpty
                          ? null
                          : () {
                              // Lanjutkan ke halaman checkout; event akan dipicu di sana
                              context.push('/checkout');
                            },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}