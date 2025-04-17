import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splittymate/ui/themes.dart';

class ChangeGroupNameDialog extends StatefulWidget {
  const ChangeGroupNameDialog({super.key});

  @override
  State<ChangeGroupNameDialog> createState() => _ChangeGroupNameDialogState();
}

class _ChangeGroupNameDialogState extends State<ChangeGroupNameDialog> {
  final _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        title: const Text(
          'Group name',
          textAlign: TextAlign.center,
        ),
        content: TextFormField(
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter a name' : null,
          controller: _name,
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
                if (valid) Navigator.of(context).pop(_name.text);
              },
              child: const Icon(Icons.check_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
