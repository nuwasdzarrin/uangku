import 'package:intl/intl.dart';

class Formatter {
  String formatNumber(int number) {
    NumberFormat formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}