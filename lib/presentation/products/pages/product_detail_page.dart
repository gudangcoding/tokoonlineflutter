import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../products/bloc/product_bloc.dart';
import '../../products/bloc/product_event.dart';
import '../../products/bloc/product_state.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../component/app_snackbar.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  const ProductDetailPage({super.key, required this.id});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading || state.detail == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final p = state.detail!;
          return LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 360;
              final imageHeight = isSmall ? 160.0 : 220.0;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Container(
                      height: imageHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        image: p.imageUrl.isNotEmpty
                            ? DecorationImage(image: NetworkImage(p.imageUrl), fit: BoxFit.cover)
                            : null,
                      ),
                      child: p.imageUrl.isEmpty ? const Center(child: Icon(Icons.image_not_supported)) : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      p.name,
                      style: isSmall ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${p.price.toStringAsFixed(0)}',
                      style: isSmall ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(p.description.isEmpty ? 'Tidak ada deskripsi.' : p.description),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(AddToCart(p));
                        AppSnackbar.show(context, 'Ditambahkan ke keranjang', type: SnackbarType.success);
                      },
                      child: const Text('Tambah ke Keranjang'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}