import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';
import '../../../core/network/api_client.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiClient? apiClient;
  CartBloc({this.apiClient}) : super(const CartState()) {
    on<AddToCart>(_onAdd);
    on<RemoveFromCart>(_onRemove);
    on<ClearCart>(_onClear);
    on<CheckoutRequested>(_onCheckout);
  }

  void _onAdd(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.product.id == event.product.id);
    if (idx >= 0) {
      items[idx] = CartItem(items[idx].product, items[idx].qty + 1);
    } else {
      items.add(CartItem(event.product, 1));
    }
    emit(state.copyWith(items: items, status: CartStatus.updating));
    emit(state.copyWith(status: CartStatus.idle));
  }

  void _onRemove(RemoveFromCart event, Emitter<CartState> emit) {
    final items = state.items.where((i) => i.product.id != event.productId).toList();
    emit(state.copyWith(items: items, status: CartStatus.updating));
    emit(state.copyWith(status: CartStatus.idle));
  }

  void _onClear(ClearCart event, Emitter<CartState> emit) {
    emit(state.copyWith(items: [], status: CartStatus.updating));
    emit(state.copyWith(status: CartStatus.idle));
  }

  Future<void> _onCheckout(CheckoutRequested event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.checkingOut));
    try {
      // Example API payload structure; adjust to your backend
      await apiClient?.post('/checkout', data: {
        'items': state.items
            .map((i) => {'product_id': i.product.id, 'qty': i.qty, 'price': i.product.price})
            .toList(),
        'total': state.total,
        'address': event.address,
        'payment_method': event.paymentMethod,
      });
      emit(state.copyWith(status: CartStatus.success));
      emit(state.copyWith(items: [], status: CartStatus.idle));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, message: 'Checkout gagal: $e'));
      emit(state.copyWith(status: CartStatus.idle));
    }
  }
}