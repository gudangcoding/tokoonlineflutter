import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  const CategoryCard({
    super.key,
    required this.label,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200;
    final textColor = selected ? Colors.white : Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.category, color: selected ? Colors.white : Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}