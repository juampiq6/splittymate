import 'package:flutter/material.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/ui/transaction/tile/date_box.dart';
import 'package:splittymate/ui/themes.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.participants,
    required this.payers,
    required this.onTap,
    required this.currency,
  });

  final String title;
  final DateTime date;
  final double amount;
  final String currency;
  final List<User> participants;
  final List<User> payers;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: context.tt.labelLarge),
      leading: DateBox(date: date),
      onTap: onTap,
      subtitle: ExpenseTileSubtitle(payers: payers, participants: participants),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amount.toStringAsFixed(2),
            style: context.tt.labelMedium,
          ),
          const SizedBox(width: 4),
          Text(currency.toUpperCase()),
        ],
      ),
    );
  }
}

class ExpenseTileSubtitle extends StatelessWidget {
  const ExpenseTileSubtitle(
      {super.key, required this.payers, required this.participants});

  final List<User> payers;
  final List<User> participants;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.payments_outlined,
              size: 19,
            ),
            const SizedBox(width: 8),
            Text(
              payers.map((p) => p.name).join(', '),
              style: context.tt.bodyMedium,
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.people_alt_outlined,
              size: 19,
            ),
            const SizedBox(width: 8),
            Text(
              participants.map((p) => p.name).join(', '),
              style: context.tt.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
