part of 'new_payment_form.dart';

class PaymentPayerChips extends StatelessWidget {
  const PaymentPayerChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPaymentBloc, NewPaymentState>(
      builder: (context, state) {
        return ExpenseUserSelectableChips(
          selectedUsers: {
            for (final member in state.members)
              member: state.payerId == member.id,
          },
          onUserSelected: (User user) {
            context.read<NewPaymentBloc>().add(
                  NewPaymentPayerToggledEvent(user.id),
                );
          },
        );
      },
    );
  }
}
