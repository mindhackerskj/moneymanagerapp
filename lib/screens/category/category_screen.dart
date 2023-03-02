import 'package:flutter/material.dart';
import 'package:moneyapp/db/category/actions.dart';
import 'package:moneyapp/screens/category/expense_category-list.dart';
import 'package:moneyapp/screens/category/income_category_list.dart';
import 'package:moneyapp/screens/home/widgets/bottomnav.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    Categorydb().refreshUi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'INCOME',
              ),
              Tab(
                text: 'EXPENSE',
              )
            ]),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: [IncomeCategoryList(), ExpenseCategoryList()]),
        )
      ],
    );
  }
}
