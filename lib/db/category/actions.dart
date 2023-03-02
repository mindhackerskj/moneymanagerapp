import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneyapp/models/category/category_model.dart';

const Category_DB = 'category_db';

abstract class CategoryActions {
  Future<void> insertValue(CategoryModel value);
  Future<List<CategoryModel>> getList();
  Future<void> deleteValue(String categoryId);
}

class Categorydb implements CategoryActions {
  Categorydb._internal();
  static Categorydb instance = Categorydb._internal();

  factory Categorydb() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);

  @override
  Future<void> insertValue(CategoryModel value) async {
    final _categorydb = await Hive.openBox<CategoryModel>(Category_DB);
    await _categorydb.put(value.id, value);
    refreshUi();
  }

  @override
  Future<List<CategoryModel>> getList() async {
    final _categorydb = await Hive.openBox<CategoryModel>(Category_DB);
    return _categorydb.values.toList();
  }

  Future<void> refreshUi() async {
    final categories = await getList();
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();
    await Future.forEach(categories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryList.value.add(category);
      } else {
        expenseCategoryList.value.add(category);
      }
    });
    expenseCategoryList.notifyListeners();
    incomeCategoryList.notifyListeners();
  }

  @override
  Future<void> deleteValue(String categoryId) async {
    final _categorydb = await Hive.openBox<CategoryModel>(Category_DB);
    _categorydb.delete(categoryId);
    refreshUi();
  }
}
