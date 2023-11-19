import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;

  void openDialog() {
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Name"
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(onPressed: () {}, child: const Text("Save"))
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
    return SafeArea(
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
                        openDialog();
                      },
                      icon: const Icon(Icons.add)
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 10,
                child: ListTile(
                  leading: isExpense ?
                    const Icon(Icons.upload, color: Colors.red,)
                    : const Icon(Icons.download, color: Colors.green,),
                  title: const Text("Sedekah"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                      const SizedBox(width: 10,),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 10,
                child: ListTile(
                  leading: isExpense ?
                    const Icon(Icons.upload, color: Colors.red,)
                    : const Icon(Icons.download, color: Colors.green,),
                  title: const Text("Sedekah"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                      const SizedBox(width: 10,),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}
