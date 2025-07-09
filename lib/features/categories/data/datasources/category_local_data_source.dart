import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  Future<void> saveCategories(List<Category> categories);
  Future<List<Category>> getCategories();
  Future<void> saveCategory(Category category);
  Future<Category?> getCategoryById(String id);
  Future<void> deleteCategory(String id);
  Future<void> clearCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  CategoryLocalDataSourceImpl({required this.sharedPreferences});
  
  static const String _categoriesKey = 'categories';
  static const String _categoryPrefix = 'category_';
  
  @override
  Future<void> saveCategories(List<Category> categories) async {
    final categoriesJson = categories.map((category) => _categoryToJson(category)).toList();
    await sharedPreferences.setString(_categoriesKey, jsonEncode(categoriesJson));
  }
  
  @override
  Future<List<Category>> getCategories() async {
    final categoriesJson = sharedPreferences.getString(_categoriesKey);
    if (categoriesJson == null) {
      return [];
    }
    
    final List<dynamic> categoriesList = jsonDecode(categoriesJson);
    return categoriesList.map((json) => _categoryFromJson(json)).toList();
  }
  
  @override
  Future<void> saveCategory(Category category) async {
    final categories = await getCategories();
    final existingIndex = categories.indexWhere((c) => c.id == category.id);
    
    if (existingIndex != -1) {
      categories[existingIndex] = category;
    } else {
      categories.add(category);
    }
    
    await saveCategories(categories);
    
    // Also save individual category for quick access
    await sharedPreferences.setString(
      '$_categoryPrefix${category.id}',
      jsonEncode(_categoryToJson(category)),
    );
  }
  
  @override
  Future<Category?> getCategoryById(String id) async {
    final categoryJson = sharedPreferences.getString('$_categoryPrefix$id');
    if (categoryJson == null) {
      return null;
    }
    
    return _categoryFromJson(jsonDecode(categoryJson));
  }
  
  @override
  Future<void> deleteCategory(String id) async {
    final categories = await getCategories();
    categories.removeWhere((category) => category.id == id);
    await saveCategories(categories);
    
    // Remove individual category
    await sharedPreferences.remove('$_categoryPrefix$id');
  }
  
  @override
  Future<void> clearCategories() async {
    await sharedPreferences.remove(_categoriesKey);
    
    // Remove all individual category keys
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_categoryPrefix)) {
        await sharedPreferences.remove(key);
      }
    }
  }
  
  Map<String, dynamic> _categoryToJson(Category category) {
    return {
      'id': category.id,
      'name': category.name,
      'description': category.description,
      'icon': category.icon,
      'color': category.color,
      if (category.createdAt != null) 'createdAt': category.createdAt!.toIso8601String(),
      if (category.updatedAt != null) 'updatedAt': category.updatedAt!.toIso8601String(),
    };
  }
  
  Category _categoryFromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }
} 