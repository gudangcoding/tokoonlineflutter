import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/products/product_repository.dart';
import '../../../domain/products/product_entity.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetail>(_onLoadProductDetail);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading, page: 1, query: event.query, hasMore: true));
    try {
      final items = await repository.getProducts(query: event.query, page: 1, limit: 8);
      emit(state.copyWith(
        status: ProductStatus.loaded,
        products: items,
        page: 1,
        hasMore: items.length == 8,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: 'Gagal memuat produk: $e'));
    }
  }

  Future<void> _onLoadProductDetail(LoadProductDetail event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final item = await repository.getProductDetail(event.id);
      emit(state.copyWith(status: ProductStatus.loaded, detail: item));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, message: 'Gagal memuat detail: $e'));
    }
  }

  Future<void> _onLoadMoreProducts(LoadMoreProducts event, Emitter<ProductState> emit) async {
    if (!state.hasMore || state.isLoadingMore || state.status == ProductStatus.loading) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final items = await repository.getProducts(query: state.query, page: nextPage, limit: 8);
      final merged = List<ProductEntity>.from(state.products)..addAll(items);
      emit(state.copyWith(
        products: merged,
        page: nextPage,
        hasMore: items.length == 8,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, message: 'Gagal memuat halaman berikutnya: $e'));
    }
  }

  Future<void> _onRefreshProducts(RefreshProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isRefreshing: true, page: 1, hasMore: true));
    try {
      final items = await repository.getProducts(query: state.query, page: 1, limit: 8);
      emit(state.copyWith(
        status: ProductStatus.loaded,
        products: items,
        page: 1,
        hasMore: items.length == 8,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(state.copyWith(isRefreshing: false, status: ProductStatus.error, message: 'Gagal refresh: $e'));
    }
  }
}