import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moneyapp/db/category/actions.dart';
import 'package:moneyapp/db/transaction/transaction_db.dart';
import 'package:moneyapp/models/category/category_model.dart';
import 'package:moneyapp/screens/home/widgets/bottomnav.dart';

import '../../models/transaction/transaction_model.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    Categorydb.instance.refreshUi();

    return ValueListenableBuilder(
        valueListenable: TransactionDb.instance.transactionNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: ((ctx, index) {
                final value = newList[index];
                return Slidable(
                  key: Key(value.id!),
                  startActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDb.instance.deleteTransaction(value.id!);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                    )
                  ]),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 50,
                        child: Text(
                          parseDate(value.dateTime),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: value.type == CategoryType.income
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text('Rs. ${value.amount} '),
                      subtitle: Text(' ${value.category.name}'),
                    ),
                  ),
                );
              }),
              separatorBuilder: (ctx, inx) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newList.length);
        });
  }

  String parseDate(DateTime date) {
    final ddate = DateFormat.MMMd().format(date);
    final splitted = ddate.split(' ');
    return '${splitted.last}\n${splitted.first}';
  }
}
