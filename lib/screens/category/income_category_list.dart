import 'package:flutter/material.dart';
import '../../db/category/actions.dart';
import '../../models/category/category_model.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Categorydb().incomeCategoryList,
        builder:
            (BuildContext context, List<CategoryModel> newList, Widget? _) {
          return ListView.separated(
              itemBuilder: (ctx, inx) {
                final category = newList[inx];
                return Card(
                  child: ListTile(
                    title: Text(category.name),
                    trailing: IconButton(
                      onPressed: () {
                        Categorydb.instance.deleteValue(category.id);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, inx) {
                return SizedBox(height: 10);
              },
              itemCount: newList.length);
        });
  }
}
