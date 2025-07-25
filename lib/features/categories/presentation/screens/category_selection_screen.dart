import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_providers.dart';

class CategorySelectionScreen extends ConsumerStatefulWidget {
  final String? selectedCategoryId;
  const CategorySelectionScreen({super.key, this.selectedCategoryId});

  @override
  ConsumerState<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends ConsumerState<CategorySelectionScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final notifier = ref.read(categoriesInfiniteScrollProvider.notifier);
      if (notifier.hasMoreData) {
        setState(() => _isLoadingMore = true);
        notifier.loadNextPage().whenComplete(() => setState(() => _isLoadingMore = false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesInfiniteScrollProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) => ListView.builder(
          controller: _scrollController,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.id == widget.selectedCategoryId;
            return ListTile(
              title: Text(category.name),
              selected: isSelected,
              trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () => Navigator.of(context).pop(category),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load categories')), 
      ),
    );
  }
} 