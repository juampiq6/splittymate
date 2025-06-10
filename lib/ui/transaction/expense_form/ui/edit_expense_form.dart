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

class EditExpenseForm extends ConsumerWidget {
  final SplitGroup splitGroup;
  final Transaction expense;
  const EditExpenseForm(
      {super.key, required this.splitGroup, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialState = EditExpenseState(
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
      updatedBy: expense.updatedBy,
      id: expense.id,
      name: expense.title,
      date: expense.date,
      payers: expense.payersIds
          .map((p) => splitGroup.members.firstWhere((m) => m.id == p))
          .toList(),
      participants: expense.participantsIds
          .map((p) => splitGroup.members.firstWhere((m) => m.id == p))
          .toList(),
      isEquallyShared: expense is EqualShareExpense,
      payShares: expense.payShares,
      participantShares: expense.shares,
      currency: expense.currency,
      status: FormSubmissionStatus.initial,
      errorMessage: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
      ),
      body: BlocProvider(
        create: (context) => ExpenseFormBloc(
          txNotifier: ref.read(transactionsProvider(splitGroup.id).notifier),
          groupId: splitGroup.id,
          members: splitGroup.members,
          initialState: initialState,
        ),
        child:
            BlocListener<ExpenseFormBloc<EditExpenseState>, EditExpenseState>(
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
                context.go(AppRoute.transactionDetail.path(
                  parameters: {'groupId': splitGroup.id, 'txId': expense.id},
                ));
              case FormSubmissionStatus.failure:
                // Pop the loading dialog
                context.pop();
                final messenger = ScaffoldMessenger.of(context);
                messenger.hideCurrentSnackBar();
                messenger
                    .showSnackBar(
                      const SnackBar(
                        content: Text('Error editing expense, try again later'),
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
            final bloc = context.read<ExpenseFormBloc<EditExpenseState>>();
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
                        Expanded(
                          child: ExpenseTitleField(bloc: bloc),
                        ),
                        const SizedBox(width: 20),
                        ExpenseDateButton(bloc: bloc),
                      ],
                    ),
                    // const SizedBox(height: 15),
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
                        members: splitGroup.members,
                        bloc: bloc,
                      ),
                    ),
                    ExpenseParticipantsAmountInput(bloc: bloc),
                    const SizedBox(height: 20),
                    Text(
                      'Payers',
                      style: context.tt.titleLarge,
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: ExpensePayersChips(
                        members: splitGroup.members,
                        bloc: bloc,
                      ),
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
