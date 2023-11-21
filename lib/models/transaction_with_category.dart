import 'package:uangku/models/database.dart';

class TransactionWithCategory {
  final MoneyTransactionData transaction;
  final Category category;
  TransactionWithCategory(this.transaction, this.category);
}