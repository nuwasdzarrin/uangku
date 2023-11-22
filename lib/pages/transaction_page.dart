import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uangku/models/database.dart';
import 'package:uangku/models/transaction_with_category.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({super.key, required this.transactionWithCategory});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  Category? categorySelected;
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  final AppDatabase database = AppDatabase();
  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }
  Future insert () async {
    DateTime now = DateTime.now();
    final result = await database.into(database.moneyTransaction).insertReturning(
        MoneyTransactionCompanion.insert(
            categoryId: categorySelected!.id,
            name: noteController.text,
            amount: int.parse(amountController.text),
            transactionDate: DateTime.parse(dateController.text),
            createdAt: now,
            updatedAt: now
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.transactionWithCategory != null) {
      updateTransaction(widget.transactionWithCategory);
    }
    super.initState();
  }

  void updateTransaction(TransactionWithCategory? transactionWithCategory) {
    amountController.text = transactionWithCategory!.transaction.amount.toString();
    noteController.text = transactionWithCategory.transaction.name.toString();
    dateController.text = DateFormat("yyyy-MM-dd").format(transactionWithCategory.transaction.transactionDate);
    isExpense = transactionWithCategory.category.type as bool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25,),
              Row(
                children: [
                  Switch(
                    value: isExpense,
                    onChanged: (bool value) {
                      setState(() {
                        isExpense = value;
                      });
                      categorySelected = null;
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  Text(
                    isExpense ? "Expense" : "Income",
                    style: GoogleFonts.montserrat(
                        fontSize: 14
                    ),
                  )
                ]
              ),
              const SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Amount"
                  ),
                )
              ),
              const SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Category",
                  style: GoogleFonts.montserrat(
                    fontSize: 16
                  ),
                ),
              ),
              FutureBuilder<List<Category>>(
                  future: getAllCategory(isExpense ? 2 : 1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        categorySelected = categorySelected ?? snapshot.data!.first;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,),
                          child: DropdownButton<Category>(
                            isExpanded: true,
                            value: categorySelected ?? snapshot.data!.first,
                            icon: const Icon(Icons.arrow_downward),
                            items: snapshot.data!.map((Category item) {
                              return DropdownMenuItem<Category>(
                                value: item,
                                child: Text(item.name),
                              );
                            }).toList(),
                            onChanged: ((Category? value) {
                              setState(() {
                                categorySelected = value;
                              });
                            }),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("Category not found"),
                        );
                      }
                    }
                  }
              ),
              const SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, ),
                child: TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: const InputDecoration(
                      labelText: "Enter Date",
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2099)
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                      dateController.text = formattedDate;
                    }
                  },
                ),
              ),
              const SizedBox(height: 25,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,),
                  child: TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Note"
                    ),
                  )
              ),
              const SizedBox(height: 25,),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      insert();
                      Navigator.pop(context, true);
                    },
                    child: const Text("Save")
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
