import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/currency.dart';
import 'package:splittymate/models/split_group.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/user_groups_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/split_group/balance_sum_up.dart';
import 'package:splittymate/ui/split_group/settings/change_default_currency_dialog.dart';
import 'package:splittymate/ui/split_group/transactions_list.dart';
import 'package:splittymate/ui/split_group/settings/invitation/invitation_link_dialog.dart';
import 'package:splittymate/ui/themes.dart';

class SplitGroupHome extends ConsumerWidget {
  final SplitGroup group;
  const SplitGroupHome({super.key, required this.group});

  changeDefaultCurrency(BuildContext context, WidgetRef ref) async {
    final currency = await showDialog<Currency?>(
      context: context,
      builder: (context) {
        return const SelectCurrencyDialog(
          title: 'Default currency',
        );
      },
    );
    if (currency != null) {
      await ref
          .read(splitGroupProvider(group.id).notifier)
          .updateGroupCurrency(currency.code);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          // SETTINGS
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go(
                  AppRoute.splitGroupSettings
                      .path(parameters: {'groupId': group.id}),
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
              onPressed: () => context.go(AppRoute.splitGroupBalances.path(
                parameters: {'groupId': group.id},
              )),
              child: const Text('Balances'),
            ),
          ),
          const Expanded(child: SizedBox()),
          if (group.members.length > 1)
            Row(
              children: [
                FloatingActionButton(
                  heroTag: 'new_payment',
                  onPressed: () => context.go(
                    AppRoute.newPaymentForm.path(
                      parameters: {'groupId': group.id},
                    ),
                  ),
                  child: const Icon(Icons.payments_outlined),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'new_expense',
                  onPressed: () => context.go(
                    AppRoute.newExpenseForm.path(
                      parameters: {'groupId': group.id},
                    ),
                  ),
                  child: const Icon(Icons.list_alt_rounded),
                ),
              ],
            ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async => ref
            .read(userSplitGroupsProvider.notifier)
            .fetchGroupAndUpdate(group.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalancesSumUpHeader(
              group: group,
            ),
            const Divider(
              height: 0,
            ),
            if (group.members.length <= 1)
              // this scrollview is necessary to allow the refresh gesture
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Add friends to start adding expenses',
                      style: context.tt.bodyMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: OutlinedButton(
                        child: const Text('Invite friend'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return InvitationLinkDialog(
                                groupId: group.id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: GroupTransactionList(group: group),
              ),
          ],
        ),
      ),
    );
  }
}
