import 'package:flutter/material.dart';
import 'package:moneyapp/db/category/actions.dart';
import 'package:moneyapp/models/category/category_model.dart';
import 'package:moneyapp/screens/addtransaction/add_transaction.dart';
import 'package:moneyapp/screens/category/add_popup.dart';
import 'package:moneyapp/screens/category/category_screen.dart';
import 'package:moneyapp/screens/home/widgets/bottomnav.dart';
import 'package:moneyapp/screens/transactions/transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  final pages = const [TransactionScreen(), CategoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Manager'),
        centerTitle: true,
      ),
      bottomNavigationBar: const Bottomnav(),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: ((BuildContext context, int newIndex, _) {
                return pages[newIndex];
              }))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndex.value == 0) {
            print('Add transaction');
            Navigator.of(context).pushNamed(AddTransaction.routeName);
          } else {
            print('Add category');
            // final _demo = CategoryModel(
            //     id: 'x1', name: 'Salary', type: CategoryType.income);
            // Categorydb().insert(_demo);
            AddCategoryPopup(context);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
