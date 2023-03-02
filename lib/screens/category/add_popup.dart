import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneyapp/db/category/actions.dart';
import 'package:moneyapp/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategory =
    ValueNotifier(CategoryType.income);

Future<void> AddCategoryPopup(BuildContext context) async {
  final _nameController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: 'Category name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(children: [
                RadioButton(title: 'Income', type: CategoryType.income),
                RadioButton(title: 'Expense', type: CategoryType.expense),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text;
                    final category = selectedCategory.value;
                    if (name.isEmpty) {
                      return;
                    }
                    final _category = CategoryModel(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        name: name,
                        type: category);
                    Categorydb().insertValue(_category);
                    Navigator.of(context).pop();
                  },
                  child: Text('Add')),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategory,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                  value: type,
                  groupValue: selectedCategory.value,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategory.value = value;
                    selectedCategory.notifyListeners();
                  });
            }),
        Text(title)
      ],
    );
  }
}
