import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/currency.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/currencies_provider.dart';
import 'package:splittymate/ui/split_group/balance_sum_up.dart';
import 'package:splittymate/ui/split_group/change_default_currency_dialog.dart';
import 'package:splittymate/ui/split_group/expenses_list.dart';
import 'package:splittymate/ui/split_group/invitation/invite_user_dialog.dart';

class SplitGroupHome extends ConsumerWidget {
  final SplitGroup group;
  const SplitGroupHome({super.key, required this.group});

  changeDefaultCurrency(BuildContext context) async {
    final currency = await showDialog<Currency?>(
      context: context,
      builder: (context) {
        return const DefaultCurrencyDialog();
      },
    );
    if (currency != null) {
      // TODO change group default currency
    }
  }

  inviteUserToGroup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return InviteUserDialog(groupId: group.id);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultCurrency = group.defaultCurrency;
    final currency = ref.watch(currenciesProvider)[defaultCurrency]!;
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          // CURRENCY
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: OutlinedButton(
              style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              child: Text('${currency.symbol} ${currency.code}'),
              onPressed: () {
                changeDefaultCurrency(context);
              },
            ),
          ),
          // ADD MEMBER
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: OutlinedButton(
              style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              child: const Icon(Icons.add_reaction_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return InviteUserDialog(
                      groupId: group.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: OutlinedButton(
              onPressed: () => context.go('/split_group/${group.id}/balances'),
              child: const Text('Balances'),
            ),
          ),
          const Expanded(child: SizedBox()),
          FloatingActionButton(
            heroTag: 'new_payment',
            onPressed: () => context.go(
              '/split_group/${group.id}/new_payment',
            ),
            child: const Icon(Icons.payments_outlined),
          ),
          FloatingActionButton(
            heroTag: 'new_expense',
            onPressed: () => context.go(
              '/split_group/${group.id}/new_expense',
            ),
            child: const Icon(Icons.list_alt_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BalancesSumUpHeader(
            group: group,
          ),
          const Divider(
            height: 0,
          ),
          Expanded(
            child: GroupTransactionList(group: group),
          ),
        ],
      ),
    );
  }
}
