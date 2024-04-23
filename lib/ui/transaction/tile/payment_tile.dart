import 'package:flutter/material.dart';
import 'package:splittymate/models/user.dart';
import 'package:splittymate/ui/transaction/tile/date_box.dart';
import 'package:splittymate/ui/themes.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({
    super.key,
    required this.date,
    required this.amount,
    required this.currency,
    required this.payee,
    required this.payer,
    required this.onTap,
  });

  final DateTime date;
  final double amount;
  final String currency;
  final User payee;
  final User payer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(
            payer.name,
            style: context.tt.labelLarge,
          ),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_circle_right_outlined),
          const SizedBox(width: 5),
          Text(
            payee.name,
            style: context.tt.labelLarge,
          ),
        ],
      ),
      leading: DateBox(date: date),
      onTap: onTap,
      // subtitle: Text('${payer.name} to ${payee.name}'),
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
