import 'package:flutter/material.dart';
import 'package:splittymate/ui/themes.dart';

class ChangeGroupDescriptionDialog extends StatefulWidget {
  const ChangeGroupDescriptionDialog({super.key});

  @override
  State<ChangeGroupDescriptionDialog> createState() =>
      _ChangeGroupDescriptionDialogState();
}

class _ChangeGroupDescriptionDialogState
    extends State<ChangeGroupDescriptionDialog> {
  final _desc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        title: const Text(
          'Group description',
          textAlign: TextAlign.center,
        ),
        content: TextFormField(
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter a description'
              : null,
          controller: _desc,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: context.theme.colorScheme.secondaryContainer,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close_rounded,
            ),
          ),
          Builder(
            builder: (context) => FilledButton(
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                final valid = Form.of(context).validate();
                if (valid) Navigator.of(context).pop(_desc.text);
              },
              child: const Icon(Icons.check_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
