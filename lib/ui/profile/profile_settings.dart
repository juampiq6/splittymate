import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/ui/profile/avatar_loader.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/utils.dart';

class ProfileSettings extends ConsumerWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AvatarLoader(
                email: user.email,
                nickname: user.nickname,
                size: 120,
              ),
              const SizedBox(
                height: 30,
              ),
              ProfileEditableItem(
                title: 'Name',
                value: user.name,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                onChanged: (v) {
                  if (v != null && v.isNotEmpty) {
                    ref
                        .read(userProvider.notifier)
                        .updateUser(user.copyWith(name: v));
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ProfileEditableItem(
                title: 'Surname',
                value: user.surname,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Surname cannot be empty';
                  }
                  return null;
                },
                onChanged: (v) {
                  if (v != null && v.isNotEmpty) {
                    ref
                        .read(userProvider.notifier)
                        .updateUser(user.copyWith(surname: v));
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ProfileEditableItem(
                title: 'Email',
                value: user.email,
                validator: (v) {
                  if (v != null && isValidEmail(v)) return null;
                  return 'Invalid email';
                },
                onChanged: (v) {
                  if (v != null && v.isNotEmpty) {
                    ref.read(userProvider.notifier).updateUserEmail(v);
                  }
                },
              ),
            ],
          ),
        ));
  }
}

class ProfileEditableItem extends StatelessWidget {
  final String title;
  final String value;
  final Function(String?) onChanged;
  final String? Function(String?) validator;
  const ProfileEditableItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: context.tt.displayMedium,
            ),
            const SizedBox(
              width: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final v = await showDialog<String?>(
                      context: context,
                      builder: (context) {
                        return EditItemDialog(
                          title: title,
                          validator: validator,
                        );
                      },
                    );
                    await onChanged(v);
                  }),
            ),
          ],
        ),
      ],
    );
  }
}

class EditItemDialog extends StatelessWidget {
  final String title;
  final String? Function(String?) validator;
  const EditItemDialog({
    super.key,
    required this.title,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Form(
      child: AlertDialog(
        title: Text(title),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(),
          validator: validator,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          Builder(
            builder: (context) => TextButton(
              onPressed: () {
                if (Form.of(context).validate()) {
                  Navigator.of(context).pop(controller.text);
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
