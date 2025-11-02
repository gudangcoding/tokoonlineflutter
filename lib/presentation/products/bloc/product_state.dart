import '../../../domain/products/product_entity.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductState {
  final ProductStatus status;
  final List<ProductEntity> products;
  final ProductEntity? detail;
  final String? message;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? query;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.detail,
    this.message,
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.query,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductEntity>? products,
    ProductEntity? detail,
    String? message,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? query,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      detail: detail ?? this.detail,
      message: message ?? this.message,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      query: query ?? this.query,
    );
  }
}