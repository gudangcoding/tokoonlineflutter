import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../products/bloc/product_bloc.dart';
import '../../products/bloc/product_state.dart';
import '../../products/bloc/product_event.dart';
import '../../component/category_card.dart';
// pagination bar dihapus: diganti infinite scroll + pull-to-refresh

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _categories = const [
    'Semua', 'Elektronik', 'Fashion', 'Kecantikan', 'Olahraga', 'Rumah', 'Makanan', 'Lainnya'
  ];
  String _selectedCategory = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _doSearch() {
    final q = _searchController.text.trim();
    context.read<ProductBloc>().add(LoadProducts(query: q.isEmpty ? null : q));
  }

  void _selectCategory(String label) {
    setState(() {
      _selectedCategory = label;
    });
    // Untuk saat ini, gunakan label kategori sebagai query sederhana
    if (label == 'Semua') {
      context.read<ProductBloc>().add(LoadProducts());
    } else {
      context.read<ProductBloc>().add(LoadProducts(query: label));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final loading = state.status == ProductStatus.loading;
        if (state.status == ProductStatus.error) {
          return Center(child: Text(state.message ?? 'Gagal memuat produk'));
        }
        final products = state.products;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari produk...',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _doSearch(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    tooltip: 'Profil',
                    onPressed: () => context.push('/profile'),
                    icon: const Icon(Icons.person),
                  ),
                  IconButton(
                    tooltip: 'Notifikasi',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifikasi belum tersedia')),
                    ),
                    icon: const Icon(Icons.notifications),
                  ),
                  IconButton(
                    tooltip: 'Pesan',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pesan belum tersedia')),
                    ),
                    icon: const Icon(Icons.message),
                  ),
                ],
              ),
            ),

            // Kategori horizontal
            SizedBox(
              height: 96,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final label = _categories[index];
                  return CategoryCard(
                    label: label,
                    selected: _selectedCategory == label,
                    onTap: () => _selectCategory(label),
                  );
                },
              ),
            ),

            // Daftar produk dengan pull-to-refresh & infinite scroll
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : (products.isEmpty
                      ? const Center(child: Text('Produk belum tersedia'))
                      : RefreshIndicator(
                          onRefresh: () async {
                            final bloc = context.read<ProductBloc>();
                            bloc.add(RefreshProducts());
                            await bloc.stream.firstWhere((s) => !s.isRefreshing);
                          },
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
                                context.read<ProductBloc>().add(LoadMoreProducts());
                              }
                              return false;
                            },
                            child: GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(12),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.72,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: products.length + (state.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= products.length) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final p = products[index];
                                return InkWell(
                                  onTap: () => context.push('/product/${p.id}'),
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: (p.imageUrl.isEmpty)
                                              ? const Icon(Icons.image_not_supported)
                                              : CachedNetworkImage(
                                                  imageUrl: p.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
                                                ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Text('Rp ${p.price.toStringAsFixed(0)}'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )),
            ),
          ],
        );
      },
    );
  }
}