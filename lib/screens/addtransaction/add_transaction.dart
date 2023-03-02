import 'package:flutter/material.dart';
import 'package:moneyapp/db/category/actions.dart';
import 'package:moneyapp/db/transaction/transaction_db.dart';
import 'package:moneyapp/models/category/category_model.dart';
import 'package:moneyapp/models/transaction/transaction_model.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  static const routeName = 'add-transcaton';

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  DateTime? _selectedDate;
  CategoryModel? _selectedCategoryModel;
  CategoryType? _selectedCategory;
  String? _categoryId;

  @override
  void initState() {
    _selectedCategory = CategoryType.expense;
    super.initState();
  }

  final purposeTextController = TextEditingController();
  final amountTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(9),
        child: Column(
          children: [
            TextFormField(
              controller: purposeTextController,
              decoration: InputDecoration(hintText: 'Purpose'),
            ),
            TextFormField(
              controller: amountTextController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Amount'),
            ),
            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now());

                if (_selectedDateTemp == null) {
                  return;
                } else {
                  print(_selectedDateTemp.toString());
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'Select Date'
                  : _selectedDate.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = CategoryType.expense;
                            _categoryId == null;
                          });
                        }),
                    Text('Expense')
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = CategoryType.income;
                            _categoryId = null;
                          });
                        }),
                    Text('Income')
                  ],
                ),
              ],
            ),
            DropdownButton(
                hint: Text('Select Category'),
                value: _categoryId,
                items: (_selectedCategory == CategoryType.expense
                        ? Categorydb().expenseCategoryList
                        : Categorydb().incomeCategoryList)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                      value: e.id,
                      onTap: () {
                        _selectedCategoryModel = e;
                      },
                      child: Text(e.name));
                }).toList(),
                onChanged: (selected) {
                  setState(() {
                    _categoryId = selected;
                    print(_categoryId);
                  });
                }),
            ElevatedButton.icon(
                onPressed: () {
                  addTransaction();
                },
                icon: Icon(Icons.check),
                label: Text('Add'))
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final purpose = purposeTextController.text;
    final amount = amountTextController.text;
    final parsedAmount = double.parse(amount);

    // if (purpose == null) {
    //   return;
    // }

     if (parsedAmount == null) {
      return;
    }

    if (_selectedDate == null) {
      return;
    }

    final _model = TransactionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      purpose: purpose,
      amount: parsedAmount,
      dateTime: _selectedDate!,
      type: _selectedCategory!,
      category: _selectedCategoryModel!,
    );

    // print(parsedAmount);
    // print(_selectedDate);
    // print(_selectedCategory);
    // print(_selectedCategoryModel);

    await TransactionDb.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDb.instance.refresh();
  }
}
