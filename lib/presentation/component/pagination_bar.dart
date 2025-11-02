import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final void Function(int) onJump;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
    required this.onJump,
  });

  @override
  Widget build(BuildContext context) {
    final pages = List<int>.generate(totalPages, (i) => i + 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 1 ? onPrev : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Wrap(
          spacing: 4,
          children: pages
              .map((p) => OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: p == currentPage ? Theme.of(context).colorScheme.primary : null,
                      foregroundColor: p == currentPage ? Colors.white : null,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 36),
                    ),
                    onPressed: () => onJump(p),
                    child: Text('$p'),
                  ))
              .toList(),
        ),
        IconButton(
          onPressed: currentPage < totalPages ? onNext : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}