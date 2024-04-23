import 'package:flutter/material.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/utils.dart';

class ExpenseDateModificationText extends StatelessWidget {
  final DateTime created;
  final DateTime updated;
  const ExpenseDateModificationText({
    super.key,
    required this.created,
    required this.updated,
  });

  @override
  Widget build(BuildContext context) {
    if (updated == created) {
      return Text(
        'Created at ${created.longFormatted()}',
        style: context.tt.bodySmall,
      );
    } else {
      return Text(
        'Updated at ${updated.longFormatted()}',
        style: context.tt.bodySmall,
      );
    }
  }
}
