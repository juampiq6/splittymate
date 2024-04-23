import 'package:flutter/material.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/utils.dart';

class ExpenseAmountRow extends StatelessWidget {
  final double amount;
  final String currency;
  const ExpenseAmountRow(
      {super.key, required this.amount, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: const Icon(
              Icons.attach_money_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            amount.priceFormatted(),
            style: context.tt.labelMedium,
          ),
          const SizedBox(width: 4),
          Text(
            currency.toUpperCase(),
            style: context.tt.bodyMedium,
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
