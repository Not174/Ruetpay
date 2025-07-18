import 'package:intl/intl.dart';

String formatTaka(double amount) {
  final formatter = NumberFormat.currency(locale: 'en_BD', symbol: '৳');
  return formatter.format(amount);
}
