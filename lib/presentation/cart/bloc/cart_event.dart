import '../../../domain/products/product_entity.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final ProductEntity product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

class ClearCart extends CartEvent {}

class CheckoutRequested extends CartEvent {
  final String address;
  final String paymentMethod;
  CheckoutRequested({required this.address, required this.paymentMethod});
}