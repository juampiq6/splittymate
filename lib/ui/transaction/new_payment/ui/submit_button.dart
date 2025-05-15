part of 'new_payment_form.dart';

class PaymentSubmitButton extends StatelessWidget {
  const PaymentSubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder<NewPaymentBloc, NewPaymentState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.isValid ||
                    state.status != FormSubmissionStatus.submitting &&
                        state.status != FormSubmissionStatus.failure
                ? () {
                    context.read<NewPaymentBloc>().add(
                          const NewPaymentSubmitEvent(),
                        );
                  }
                : null,
            child: const Text('Save'),
          );
        },
      ),
    );
  }
}
