import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/categories_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('EXPLORE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: categoriesState.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories available.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black12,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                title: Text(
                  category.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 1.2,
                    color: Colors.black87,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
                onTap: () {
                  context.push('/category/${category.slug}', extra: category.name);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
