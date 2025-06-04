import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/export.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/common/loading_dialog.dart';
import 'package:splittymate/ui/transaction/expense_form/bloc/expense_bloc.dart';
import 'package:splittymate/ui/transaction/expense_form/ui/common/expense_form_components.dart';
import 'package:splittymate/ui/transaction/form_submission_status.dart';
import 'package:splittymate/ui/themes.dart';

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
        create: (context) => ExpenseFormBloc(
          txNotifier: ref.read(transactionProvider(splitGroup.id).notifier),
          groupId: splitGroup.id,
          members: splitGroup.members,
          initialState: NewExpenseState(currency: splitGroup.defaultCurrency),
        ),
        child: BlocListener<ExpenseFormBloc<NewExpenseState>, ExpenseState>(
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
                          .read<ExpenseFormBloc>()
                          .add(const ExpenseResetErrorEvent());
                    }
                  },
                );
                break;
            }
          },
          child: Builder(builder: (context) {
            final bloc = context.read<ExpenseFormBloc<NewExpenseState>>();
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: ExpenseTitleField(bloc: bloc)),
                        const SizedBox(width: 20),
                        ExpenseDateButton(bloc: bloc),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Participants',
                          style: context.tt.titleLarge,
                        ),
                        ExpenseTypeSwitch(bloc: bloc),
                      ],
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: ExpenseParticipantsChips(
                          members: splitGroup.members, bloc: bloc),
                    ),
                    const SizedBox(height: 15),
                    ExpenseParticipantsAmountInput(bloc: bloc),
                    Text(
                      'Payers',
                      style: context.tt.titleLarge,
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: ExpensePayersChips(
                          members: splitGroup.members, bloc: bloc),
                    ),
                    const SizedBox(height: 20),
                    ExpensePayersAmountInput(bloc: bloc),
                    const Divider(
                      height: 5,
                    ),
                    ExpenseTotalAmountFooter(bloc: bloc),
                    const SizedBox(height: 20),
                    ExpenseSubmitButton(bloc: bloc),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
