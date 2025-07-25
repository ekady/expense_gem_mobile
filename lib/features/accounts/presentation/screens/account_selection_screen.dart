import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/account_providers.dart';

class AccountSelectionScreen extends ConsumerStatefulWidget {
  final String? selectedAccountId;
  const AccountSelectionScreen({super.key, this.selectedAccountId});

  @override
  ConsumerState<AccountSelectionScreen> createState() => _AccountSelectionScreenState();
}

class _AccountSelectionScreenState extends ConsumerState<AccountSelectionScreen> {
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
      final notifier = ref.read(accountsInfiniteScrollProvider.notifier);
      if (notifier.hasMoreData) {
        setState(() => _isLoadingMore = true);
        notifier.loadNextPage().whenComplete(() => setState(() => _isLoadingMore = false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsInfiniteScrollProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: accountsAsync.when(
        data: (accounts) => ListView.builder(
          controller: _scrollController,
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index];
            final isSelected = account.id == widget.selectedAccountId;
            return ListTile(
              title: Text(account.name),
              selected: isSelected,
              trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () => Navigator.of(context).pop(account),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load accounts')), 
      ),
    );
  }
} 