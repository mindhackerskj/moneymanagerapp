import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneyapp/models/transaction/transaction_model.dart';

const TRANSACTION_DB = 'transaction-db';

abstract class TransactionDbfunctions {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransaction();
  Future<void> deleteTransaction(String id);
}

class TransactionDb implements TransactionDbfunctions {
  TransactionDb._internal();
  static TransactionDb instance = TransactionDb._internal();
  factory TransactionDb() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionNotifier = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    await _db.put(transaction.id, transaction);
    print(transaction.id);
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    return _db.values.toList();
  }

  Future<void> refresh() async {
    final list = await getTransaction();
    //print(list);
    list.sort((first, second) => second.dateTime.compareTo(first.dateTime));
    transactionNotifier.value.clear();
    transactionNotifier.value.addAll(list);
    transactionNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB);
    await _db.delete(id);
    refresh();
  }
}
