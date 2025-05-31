import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/export.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/common/loading_dialog.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/transaction/form_submission_status.dart';
import 'package:splittymate/ui/transaction/payment_form/bloc/payment_bloc.dart';
import 'package:splittymate/ui/transaction/payment_form/ui/common/payment_form_components.dart';

class NewPaymentForm extends ConsumerWidget {
  final SplitGroup splitGroup;
  const NewPaymentForm({super.key, required this.splitGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Payment'),
      ),
      body: BlocProvider<PaymentFormBloc>(
        create: (context) => PaymentFormBloc(
          members: splitGroup.members,
          currency: splitGroup.defaultCurrency,
          txNotifier: ref.read<TransactionNotifier>(
              transactionProvider(splitGroup.id).notifier),
          groupId: splitGroup.id,
          initialState: NewPaymentState.initial(
            splitGroup.members,
            splitGroup.defaultCurrency,
          ),
        ),
        child: BlocListener<PaymentFormBloc, PaymentState>(
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
                context.go(AppRoute.splitGroupHome.path(parameters: {
                  'groupId': splitGroup.id,
                }));
                break;
              case FormSubmissionStatus.failure:
                // Pop the loading dialog
                context.pop();
                final messenger = ScaffoldMessenger.of(context);
                messenger.hideCurrentSnackBar();
                messenger
                    .showSnackBar(
                      const SnackBar(
                        content:
                            Text('Error creating payment, try again later'),
                      ),
                    )
                    .closed
                    .then(
                  (_) {
                    if (context.mounted) {
                      context
                          .read<PaymentFormBloc>()
                          .add(const PaymentResetErrorEvent());
                    }
                  },
                );
                break;
            }
          },
          child: Builder(builder: (context) {
            final bloc = context.read<PaymentFormBloc>();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payer',
                    style: context.tt.titleLarge,
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.center,
                    child: PaymentPayerChips(
                      bloc: bloc,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PaymentAmountInput(bloc: bloc),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'To',
                    style: context.tt.titleLarge,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PaymentPayeeChips(bloc: bloc),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'On',
                    style: context.tt.titleLarge,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PaymentDateRow(bloc: bloc),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: PaymentSubmitButton(bloc: bloc),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
