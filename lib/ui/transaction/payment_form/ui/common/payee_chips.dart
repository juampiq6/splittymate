part of 'payment_form_components.dart';

class PaymentPayeeChips extends StatelessWidget {
  final PaymentFormBloc bloc;
  const PaymentPayeeChips({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentFormBloc, PaymentState>(
      bloc: bloc,
      builder: (context, state) {
        return ExpenseUserSelectableChips(
          selectedUsers: {
            for (final member in state.possiblePayees)
              member: state.payeeId == member.id,
          },
          onUserSelected: (User user) {
            bloc.add(
              PaymentPayeeToggledEvent(user.id),
            );
          },
        );
      },
    );
  }
}
