import 'package:flutter/material.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/utils.dart';

class DateBox extends StatelessWidget {
  final DateTime date;
  const DateBox({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final compact = date.year != today.year;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 45,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey[900]!,
            width: 2.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[900]!,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
            ),
            Text(
              date.day.toString(),
              style: context.tt.labelLarge,
            ),
            Text(
              date.monthFormatted().toUpperCase(),
              style: context.tt.labelMedium,
            ),
            if (compact)
              Text(
                date.year.toString().substring(2, 4),
                style: context.tt.labelMedium,
              ),
          ],
        ),
      ),
    );
  }
}
