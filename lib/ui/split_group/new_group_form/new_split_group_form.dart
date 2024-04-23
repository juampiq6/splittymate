import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/currency.dart';
import 'package:splittymate/models/dto/group_creation_dto.dart';
import 'package:splittymate/providers/currencies_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/ui/loading_dialog.dart';
import 'package:splittymate/ui/split_group/change_default_currency_dialog.dart';

class NewSplitGroupForm extends StatefulWidget {
  const NewSplitGroupForm({super.key});

  @override
  State<NewSplitGroupForm> createState() => _NewSplitGroupFormState();
}

class _NewSplitGroupFormState extends State<NewSplitGroupForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;
  String? _photoUri;
  Currency _defaultCurrency = defaultAppCurrency;

  bool get _isFormValid => _name != null && _name!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Split Group'),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onTapOutside: (t) {
                _formKey.currentState?.validate();
              },
              onChanged: (v) {
                _name = v;
                setState(() {});
              },
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onTapOutside: (t) {
                _formKey.currentState?.validate();
              },
              onChanged: (v) {
                _description = v;
                setState(() {});
              },
            ),
            OutlinedButton(
              style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              child:
                  Text('${_defaultCurrency.symbol} ${_defaultCurrency.code}'),
              onPressed: () {
                changeDefaultCurrency(context);
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  onPressed: _isFormValid
                      ? () async {
                          try {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const LoadingFullscreenDialog();
                              },
                            );
                            await ref.read(userProvider.notifier).createGroup(
                                  GroupCreationDTO(
                                    name: _name!,
                                    description: _description,
                                    imageUrl: _photoUri,
                                    defaultCurrency: _defaultCurrency.code,
                                  ),
                                );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Error creating group, try again later',
                                  ),
                                ),
                              );
                            }
                          }
                          if (context.mounted) context.go('/');
                        }
                      : null,
                  child: const Text('Create group'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  changeDefaultCurrency(BuildContext context) async {
    final langCode = await showDialog<Currency?>(
      context: context,
      builder: (context) {
        return const DefaultCurrencyDialog();
      },
    );
    if (langCode != null) {
      _defaultCurrency = langCode;
      if (mounted) setState(() {});
    }
  }
}
