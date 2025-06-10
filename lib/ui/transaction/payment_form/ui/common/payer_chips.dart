part of 'payment_form_components.dart';

class PaymentPayerChips extends StatelessWidget {
  final PaymentFormBloc bloc;
  const PaymentPayerChips({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentFormBloc, PaymentState>(
      bloc: bloc,
      builder: (context, state) {
        return ExpenseUserSelectableChips(
          selectedUsers: {
            for (final member in state.members)
              member: state.payerId == member.id,
          },
          onUserSelected: (User user) {
            bloc.add(PaymentPayerToggledEvent(user.id));
          },
        );
      },
    );
  }
}
