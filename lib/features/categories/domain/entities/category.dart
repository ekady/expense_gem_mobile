import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final String type; // 'expense' or 'income'
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.type,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });
  
  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? colorHex,
    String? type,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    icon,
    colorHex,
    type,
    isDefault,
    createdAt,
    updatedAt,
  ];
}