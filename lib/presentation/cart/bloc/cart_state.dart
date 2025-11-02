import '../../../domain/products/product_entity.dart';

class CartItem {
  final ProductEntity product;
  final int qty;
  CartItem(this.product, this.qty);
}

enum CartStatus { idle, updating, checkingOut, success, error }

class CartState {
  final List<CartItem> items;
  final CartStatus status;
  final String? message;

  const CartState({this.items = const [], this.status = CartStatus.idle, this.message});

  double get total => items.fold(0, (sum, i) => sum + i.product.price * i.qty);

  CartState copyWith({List<CartItem>? items, CartStatus? status, String? message}) =>
      CartState(items: items ?? this.items, status: status ?? this.status, message: message ?? this.message);
}