import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uangku/pages/category_page.dart';
import 'package:uangku/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _children = [const HomePage(), const CategoryPage()];
  int currentIndex = 0;

  void onTapTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0 ? CalendarAppBar(
        accent: Colors.green,
        backButton: false,
        locale: 'id',
        onDateChanged: (value) => print(value),
        firstDate: DateTime.now().subtract(const Duration(days: 140)),
        lastDate: DateTime.now(),
      ) : PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
              child: Text(
                "Category",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
      ),
      body: _children[currentIndex],
      floatingActionButton: Visibility(
        visible: currentIndex == 0,
        child: FloatingActionButton(
          onPressed: () {},
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
                  onTapTapped(0);
                },
                icon: const Icon(Icons.home)
            ),
            const SizedBox(width: 20),
            IconButton(
                onPressed: () {
                  onTapTapped(1);
                },
                icon: const Icon(Icons.list)
            ),
          ],
        ),
      ),
    );
  }
}