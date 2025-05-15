part of 'new_payment_form.dart';

class PaymentDateRow extends StatelessWidget {
  const PaymentDateRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPaymentBloc, NewPaymentState>(
      builder: (context, state) => Column(
        children: [
          IconButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: state.date,
                firstDate: DateTime(2021),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                if (context.mounted) {
                  context.read<NewPaymentBloc>().add(
                        NewPaymentDateChangedEvent(selectedDate),
                      );
                }
              } else {
                return;
              }
            },
            padding: const EdgeInsets.all(15),
            icon: const Icon(Icons.calendar_today),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            state.date.shortFormatted(),
            style: context.tt.bodyMedium,
          ),
          // const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
