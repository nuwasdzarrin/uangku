import 'package:uangku/models/database.dart';

class TransactionWithCategory {
  final MoneyTransactionData transaction;
  final Category category;
  TransactionWithCategory(this.transaction, this.category);
}

class TransactionWithSum {
  final int? income;
  final int? expanse;
  final List<TransactionWithCategory>? allTransaction;

  TransactionWithSum({
    this.income,
    this.expanse,
    this.allTransaction
  });
}