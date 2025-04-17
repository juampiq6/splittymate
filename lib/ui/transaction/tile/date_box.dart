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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900]!,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    date.day.toString(),
                    style:
                        context.tt.labelMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: compact ? 0 : 5),
              child: Center(
                child: Text(
                  date.monthFormatted().toUpperCase(),
                  style: context.tt.labelSmall,
                ),
              ),
            ),
            if (compact)
              Center(
                child: Text(
                  date.year.toString().substring(2, 4),
                  style: context.tt.labelSmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
