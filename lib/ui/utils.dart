import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final today = DateTime.now();
bool isValidEmail(String email) {
  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}

Color colorFromString(String colorString, int alpha, double brighteness) {
  assert(alpha >= 0 && alpha <= 255, 'Alpha value must be between 0 and 255');
  assert(
    brighteness >= 0 && brighteness <= 1,
    'Brightness value must be between 0 and 1',
  );
  final hash = colorString.hashCode;
  int r = (hash & 0xFF0000) >> 16;
  int g = (hash & 0x00FF00) >> 8;
  int b = hash & 0x0000FF;

  // Mix with white to brighten it
  r = ((r * (1 - brighteness)) + (255 * brighteness)).toInt().clamp(0, 255);
  g = ((g * (1 - brighteness)) + (255 * brighteness)).toInt().clamp(0, 255);
  b = ((b * (1 - brighteness)) + (255 * brighteness)).toInt().clamp(0, 255);

  return Color.fromARGB(alpha, r, g, b);
}

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
