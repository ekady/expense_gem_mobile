import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Account({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.createdAt,
    this.updatedAt,
  });

  Account copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    icon,
    color,
    createdAt,
    updatedAt,
  ];
}
