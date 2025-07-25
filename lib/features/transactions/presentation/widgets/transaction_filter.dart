import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../accounts/presentation/providers/account_providers.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../../categories/presentation/screens/category_selection_screen.dart';
import '../../../accounts/presentation/screens/account_selection_screen.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../categories/domain/entities/category.dart';

class TransactionFilter extends ConsumerStatefulWidget {
  final String? selectedType;
  final String? selectedCategory;
  final String? selectedAccount;
  final DateTimeRange? selectedDateRange;
  final Function(String?) onTypeChanged;
  final Function(String?) onCategoryChanged;
  final Function(String?) onAccountChanged;
  final Function(DateTimeRange?) onDateRangeChanged;
  final VoidCallback onResetFilters;

  const TransactionFilter({
    super.key,
    this.selectedType,
    this.selectedCategory,
    this.selectedAccount,
    this.selectedDateRange,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onAccountChanged,
    required this.onDateRangeChanged,
    required this.onResetFilters,
  });

  @override
  ConsumerState<TransactionFilter> createState() => _TransactionFilterState();
}

class _TransactionFilterState extends ConsumerState<TransactionFilter> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool hasActiveFilters =
        widget.selectedType != null ||
        widget.selectedCategory != null ||
        widget.selectedAccount != null ||
        widget.selectedDateRange != null;

    final categoriesAsync = ref.watch(categoriesProvider);
    final accountsAsync = ref.watch(accountsProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Filter header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color:
                        hasActiveFilters
                            ? Theme.of(context).primaryColor
                            : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          hasActiveFilters
                              ? Theme.of(context).primaryColor
                              : null,
                    ),
                  ),
                  if (hasActiveFilters) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Active',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Expanded filters
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Type Filter
                  Text(
                    'Transaction Type',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'All',
                          isSelected: widget.selectedType == null,
                          onSelected: (_) => widget.onTypeChanged(null),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'Income',
                          isSelected: widget.selectedType == 'income',
                          onSelected: (_) => widget.onTypeChanged('income'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'Expense',
                          isSelected: widget.selectedType == 'expense',
                          onSelected: (_) => widget.onTypeChanged('expense'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Filter
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final categoriesAsync = ref.watch(categoriesProvider);
                          String? selectedCategoryName;
                          if (widget.selectedCategory != null) {
                            categoriesAsync.whenData((categories) {
                              selectedCategoryName =
                                  categories
                                      .firstWhere(
                                        (c) => c.id == widget.selectedCategory,
                                        orElse:
                                            () => const Category(
                                              id: '',
                                              name: '',
                                              icon: '',
                                              color: '',
                                            ),
                                      )
                                      .name;
                            });
                          }

                          return _buildFilterChip(
                            label: selectedCategoryName ?? 'All Categories',
                            isSelected: true,
                            onSelected: (_) => widget.onCategoryChanged(null),
                            onDeleted: widget.selectedCategory != null
                                ? () => widget.onCategoryChanged(null)
                                : null,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          final selected = await Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder:
                                  (_) => CategorySelectionScreen(
                                    selectedCategoryId: widget.selectedCategory,
                                  ),
                            ),
                          );
                          if (selected != null) {
                            widget.onCategoryChanged(selected.id);
                          }
                        },
                        child: const Text('Select'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Account Filter
                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final accountsAsync = ref.watch(accountsProvider);
                          String? selectedAccountName;
                          if (widget.selectedAccount != null) {
                            accountsAsync.whenData((accounts) {
                              selectedAccountName =
                                  accounts
                                      .firstWhere(
                                        (a) => a.id == widget.selectedAccount,
                                        orElse:
                                            () =>
                                                const Account(id: '', name: ''),
                                      )
                                      .name;
                            });
                          }
                          return _buildFilterChip(
                            label: selectedAccountName ?? 'All Accounts',
                            isSelected: true,
                            onSelected: (_) => widget.onAccountChanged(null),
                            onDeleted: widget.selectedAccount != null
                                ? () => widget.onAccountChanged(null)
                                : null,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          final selected = await Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder:
                                  (_) => AccountSelectionScreen(
                                    selectedAccountId: widget.selectedAccount,
                                  ),
                            ),
                          );
                          if (selected != null) {
                            widget.onAccountChanged(selected.id);
                          }
                        },
                        child: const Text('Select'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Date Range Filter
                  Text(
                    'Date Range',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final initialDateRange =
                                widget.selectedDateRange ??
                                DateTimeRange(
                                  start: DateTime.now().subtract(
                                    const Duration(days: 30),
                                  ),
                                  end: DateTime.now(),
                                );

                            final pickedDateRange = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              initialDateRange: initialDateRange,
                            );

                            if (pickedDateRange != null) {
                              widget.onDateRangeChanged(pickedDateRange);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            widget.selectedDateRange != null
                                ? '${widget.selectedDateRange!.start.month}/${widget.selectedDateRange!.start.day} - ${widget.selectedDateRange!.end.month}/${widget.selectedDateRange!.end.day}'
                                : 'Select Date Range',
                          ),
                        ),
                      ),
                      if (widget.selectedDateRange != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => widget.onDateRangeChanged(null),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Reset Filters Button
                  if (hasActiveFilters)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: widget.onResetFilters,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Reset All Filters'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
    VoidCallback? onDeleted,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      onDeleted: onDeleted,
      deleteIcon: onDeleted != null ? Icon(Icons.close, color: Theme.of(context).colorScheme.primary,) : null,
      backgroundColor: Theme.of(context).cardColor,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
