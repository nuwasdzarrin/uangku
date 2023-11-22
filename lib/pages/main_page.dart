import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uangku/pages/category_page.dart';
import 'package:uangku/pages/home_page.dart';
import 'package:uangku/pages/transaction_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex = 0;

  @override
  void initState() {
    updateView(0, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      }
      currentIndex = index;
      _children = [HomePage(selectedDate: selectedDate), const CategoryPage()];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0 ? CalendarAppBar(
        accent: Colors.green,
        backButton: false,
        locale: 'id',
        onDateChanged: (value) {
          setState(() {
            selectedDate = value;
            updateView(0, selectedDate);
          });
        },
        selectedDate: selectedDate,
        firstDate: DateTime.now().subtract(const Duration(days: 140)),
        lastDate: DateTime.now(),
      ) : PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
            child: Text(
              "Category",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          )
      ),
      body: _children[currentIndex],
      floatingActionButton: Visibility(
        visible: currentIndex == 0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TransactionPage(
                    transactionWithCategory: null,
                  )
                )
            ).then((value) {
              if (value != null) {
                setState(() {
                  selectedDate = DateTime.parse(value);
                  updateView(0, selectedDate);
                });
              }
            });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  updateView(0, DateTime.now());
                },
                icon: const Icon(Icons.home)
            ),
            const SizedBox(width: 20),
            IconButton(
                onPressed: () {
                  updateView(1, null);
                },
                icon: const Icon(Icons.list)
            ),
          ],
        ),
      ),
    );
  }
}
