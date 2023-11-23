import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
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
      appBar: currentIndex == 0 ?
        CalendarAgenda(
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 140)),
          lastDate: DateTime.now().add(const Duration(days: 8)),
          fullCalendarScroll: FullCalendarScroll.horizontal,
          selectedDayPosition: SelectedDayPosition.center,
          locale: 'id',
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
              updateView(0, selectedDate);
            });
          },
        )
        : PreferredSize(
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
                  if (value == DateFormat('yyyy-MM-dd').format(selectedDate)) {
                    final dateValue = DateTime.parse(value);
                    updateView(0, dateValue.subtract(const Duration(days: 1)));

                    Future.delayed(const Duration(milliseconds: 200), () {
                      selectedDate = dateValue;
                      updateView(0, selectedDate);
                    });
                  } else {
                    selectedDate = DateTime.parse(value);
                    updateView(0, selectedDate);
                  }
                  print("after add: $selectedDate tepe-nya: ${selectedDate.runtimeType}");
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
