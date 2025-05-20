import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String name;
  final double balance;
  final String type;
  final String? icon;
  final String? colorHex;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  const Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    this.icon,
    this.colorHex,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });
  
  Account copyWith({
    String? id,
    String? name,
    double? balance,
    String? type,
    String? icon,
    String? colorHex,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id, 
    name, 
    balance, 
    type, 
    icon, 
    colorHex, 
    isActive, 
    createdAt, 
    updatedAt,
  ];
}