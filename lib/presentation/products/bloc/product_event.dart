abstract class ProductEvent {}

class LoadProducts extends ProductEvent {
  final String? query;
  LoadProducts({this.query});
}

class LoadProductDetail extends ProductEvent {
  final String id;
  LoadProductDetail(this.id);
}

class LoadMoreProducts extends ProductEvent {}

class RefreshProducts extends ProductEvent {}