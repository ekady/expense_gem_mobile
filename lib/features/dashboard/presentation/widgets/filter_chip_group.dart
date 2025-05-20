import 'package:flutter/material.dart';

class FilterChipGroup extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final Function(String) onSelected;
  
  const FilterChipGroup({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: items.map((item) {
        final isSelected = item == selectedItem;
        
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onSelected(item);
            }
          },
          selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          checkmarkColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(
            color: isSelected 
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}