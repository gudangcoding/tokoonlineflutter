import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../products/bloc/product_bloc.dart';
import '../../products/bloc/product_event.dart';
import '../../products/bloc/product_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  void _performSearch() {
    context.read<ProductBloc>().add(LoadProducts(query: _controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pencarian')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                suffixIcon: IconButton(onPressed: _performSearch, icon: const Icon(Icons.search)),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == ProductStatus.error) {
                    return Center(child: Text(state.message ?? 'Gagal memuat hasil')); 
                  }
                  final list = state.products;
                  if (list.isEmpty) {
                    return const Center(child: Text('Tidak ada hasil.'));
                  }
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.search),
                      title: Text(list[index].name),
                      subtitle: Text('Rp ${list[index].price.toStringAsFixed(0)}'),
                      onTap: () => context.push('/product/${list[index].id}'),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}