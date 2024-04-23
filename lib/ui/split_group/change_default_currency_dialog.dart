import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/currencies_provider.dart';
import 'package:splittymate/ui/themes.dart';

class DefaultCurrencyDialog extends StatelessWidget {
  const DefaultCurrencyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currencies = ref.watch(currenciesProvider).values.toList();
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5),
          title: Text(
            'Default currency',
            style: context.tt.titleMedium,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return ListTile(
                  dense: true,
                  isThreeLine: false,
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(currency.symbol, style: context.tt.labelMedium),
                      Text(currency.code),
                    ],
                  ),
                  title: Text(
                    currency.name,
                    style: context.tt.bodyMedium,
                  ),
                  onTap: () {
                    context.pop(currency);
                  },
                );
              },
              itemCount: currencies.length,
            ),
          ),
        );
      },
    );
  }
}
