part of 'payment_form_components.dart';

class PaymentSubmitButton extends StatelessWidget {
  final PaymentFormBloc bloc;
  const PaymentSubmitButton({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder<PaymentFormBloc, PaymentState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.isValid ||
                    state.status != FormSubmissionStatus.submitting &&
                        state.status != FormSubmissionStatus.failure
                ? () {
                    bloc.add(const PaymentSubmitEvent());
                  }
                : null,
            child: const Text('Save'),
          );
        },
      ),
    );
  }
}
