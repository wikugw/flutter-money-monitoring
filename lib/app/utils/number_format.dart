import 'package:intl/intl.dart';

class MoneyFormat {
  static const _locale = 'id';
  static formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
}
