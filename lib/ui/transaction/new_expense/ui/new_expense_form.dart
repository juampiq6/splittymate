import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/export.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/common/loading_dialog.dart';
import 'package:splittymate/ui/split_group/settings/change_default_currency_dialog.dart';
import 'package:splittymate/ui/transaction/form_submission_status.dart';
import 'package:splittymate/ui/transaction/new_expense/bloc/new_expense_bloc.dart';
import 'package:splittymate/ui/transaction/user_selectable_chips.dart';
import 'package:splittymate/ui/themes.dart';
part 'participants_chips.dart';
part 'payers_chips.dart';
part 'payers_amount_input.dart';
part 'title_field.dart';
part 'date_button.dart';
part 'submit_button.dart';
part 'total_amount_footer.dart';
part 'currency_button.dart';

class NewExpenseForm extends ConsumerWidget {
  final SplitGroup splitGroup;
  const NewExpenseForm({super.key, required this.splitGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
      ),
      body: BlocProvider(
        create: (context) => NewExpenseBloc(
          txNotifier: ref.read(transactionProvider(splitGroup.id).notifier),
          groupId: splitGroup.id,
          members: splitGroup.members,
          currency: splitGroup.defaultCurrency,
        ),
        child: BlocListener<NewExpenseBloc, NewExpenseState>(
          listener: (context, state) {
            switch (state.status) {
              case FormSubmissionStatus.initial:
                break;
              case FormSubmissionStatus.submitting:
                showDialog(
                  context: context,
                  builder: (context) => const LoadingFullscreenDialog(),
                );
                break;
              case FormSubmissionStatus.success:
                context.go(AppRoute.splitGroupHome.path(
                  parameters: {'groupId': splitGroup.id},
                ));
              case FormSubmissionStatus.failure:
                // Pop the loading dialog
                context.pop();
                final messenger = ScaffoldMessenger.of(context);
                messenger.hideCurrentSnackBar();
                messenger
                    .showSnackBar(
                      const SnackBar(
                        content:
                            Text('Error creating expense, try again later'),
                      ),
                    )
                    .closed
                    .then(
                  (_) {
                    if (context.mounted) {
                      context
                          .read<NewExpenseBloc>()
                          .add(const NewExpenseResetErrorEvent());
                    }
                  },
                );
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ExpenseTitleField(),
                    ),
                    SizedBox(width: 20),
                    ExpenseDateButton(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Participants',
                      style: context.tt.titleLarge,
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.center,
                      child:
                          ExpenseParticipantsChips(members: splitGroup.members),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Payers',
                      style: context.tt.titleLarge,
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: ExpensePayersChips(members: splitGroup.members),
                    ),
                    const SizedBox(height: 20),
                    const ExpensePayersAmountInput(),
                  ],
                ),
                const Expanded(child: SizedBox()),
                const ExpenseTotalAmountFooter(),
                const SizedBox(height: 20),
                const ExpenseSubmitButton(),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
