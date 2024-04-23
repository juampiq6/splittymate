import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final today = DateTime.now();

extension Formater on DateTime {
  String longFormatted() {
    var f = DateFormat('dd MMM yyyy, HH:mm a').format(this);
    if (year == today.year) {
      f = f.substring(0, f.length - 3);
    }
    return f;
  }

  String shortFormatted() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String monthFormatted() {
    return DateFormat('MMM').format(this);
  }
}

extension MoneyFormater on double {
  String priceFormatted() {
    return NumberFormat.decimalPattern().format(this);
  }
}

TextInputFormatter numberWith3DecimalsInputFormatter =
    TextInputFormatter.withFunction((oldValue, newValue) {
  final value = double.tryParse(newValue.text);
  if (value != null && value >= 0) {
    if (newValue.text.contains('.') &&
        newValue.text.split('.').last.length > 3) {
      return TextEditingValue(
        text: value.toStringAsFixed(3),
      );
    }
    return newValue;
  }
  return oldValue;
});
