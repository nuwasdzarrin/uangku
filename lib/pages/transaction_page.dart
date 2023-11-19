import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  List<String> list = ["Makan dan Jajan", "Transportasi", "Nonton Film"];
  late String dropDownValue = list.first;
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
              const SizedBox(height: 16,),
              Row(
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
                  Text(
                    isExpense ? "Expense" : "Income",
                    style: GoogleFonts.montserrat(
                        fontSize: 14
                    ),
                  )
                ]
              ),
              const SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,),
                child: TextFormField(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropDownValue,
                  icon: const Icon(Icons.arrow_downward),
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value)
                    );
                  }).toList(),
                  onChanged: ((String? value) {}),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
