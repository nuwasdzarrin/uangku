// These imports are necessary to open the sqlite3 database
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uangku/models/category.dart';
import 'package:uangku/models/money_transaction.dart';
import 'package:uangku/models/transaction_with_category.dart';

part 'database.g.dart';

@DriftDatabase(
    tables: [Categories, MoneyTransaction]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD Category
  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)..where(
            (tbl) => tbl.type.equals(type)
    )).get();
  }
  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where(
            (tbl) => tbl.id.equals(id))
    ).write(CategoriesCompanion(name: Value(name)));
  }
  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  // CRUD Transaction
  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(DateTime date) {
    final query = (select(moneyTransaction).join(
        [
          innerJoin(
              categories, categories.id.equalsExp(moneyTransaction.categoryId)
          )
        ]
    )..where(moneyTransaction.transactionDate.equals(date)));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
            row.readTable(moneyTransaction), row.readTable(categories)
        );
      }).toList();
    });
  }
  Future summaryRepo(DateTime date) {
    final query = (select(moneyTransaction)..where(
            (tbl) => tbl.transactionDate.equals(date)
    )).get();
    return query;
  }
  Future updateTransactionRepo(int id, int amount, int categoryId,
      DateTime transactionDate, String name) async {
    return (update(moneyTransaction)..where(
            (tbl) => tbl.id.equals(id))
    ).write(MoneyTransactionCompanion(
        amount: Value(amount),
        categoryId: Value(categoryId),
        transactionDate: Value(transactionDate),
        name: Value(name),
    ));
  }
  Future deleteTransactionRepo(int id) async {
    return (delete(moneyTransaction)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}