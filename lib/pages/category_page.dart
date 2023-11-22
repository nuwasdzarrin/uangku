import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uangku/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  TextEditingController categoryNameController = TextEditingController();

  final AppDatabase database = AppDatabase();
  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name,
            type: type,
            createdAt: now,
            updatedAt: now
        )
    );
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int categoryId, String categoryName) async {
    return await database.updateCategoryRepo(categoryId, categoryName);
  }

  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      isExpense ? "Add Expense" : "Add Income",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isExpense ? Colors.red : Colors.green
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: categoryNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Name"
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                        onPressed: () {
                          category == null ?
                            insert(categoryNameController.text, isExpense ? 2 : 1)
                            : update(category.id, categoryNameController.text);
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                          setState(() {});
                          categoryNameController.clear();
                        }, 
                        child: const Text("Save")
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Switch(
                      value: isExpense,
                      onChanged: (bool value) {
                        setState(() {
                          isExpense = value;
                        });
                      },
                      inactiveTrackColor: Colors.green[200],
                      inactiveThumbColor: Colors.green,
                      activeColor: Colors.red,
                    ),
                    IconButton(
                        onPressed: () {
                          openDialog(null);
                        },
                        icon: const Icon(Icons.add)
                    )
                  ],
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
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Card(
                                  elevation: 10,
                                  child: ListTile(
                                    leading: isExpense ?
                                    const Icon(Icons.upload, color: Colors.red,)
                                        : const Icon(Icons.download, color: Colors.green,),
                                    title: Text(snapshot.data![index].name),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              database.deleteCategoryRepo(
                                                  snapshot.data![index].id
                                              );
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.delete)
                                        ),
                                        const SizedBox(width: 10,),
                                        IconButton(
                                            onPressed: () {
                                              openDialog(snapshot.data![index]);
                                            },
                                            icon: const Icon(Icons.edit)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      } else {
                        return const Center(
                          child: Text("No has data"),
                        );
                      }
                    }
                  }
              )
            ],
          )
      ),
    );
  }
}
