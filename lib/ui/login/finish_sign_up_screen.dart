import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/dto/user_creation_dto.dart';
import 'package:splittymate/providers/user_creation_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/common/debounced_build_widget.dart';
import 'package:splittymate/ui/profile/avatar_loader.dart';
import 'package:splittymate/ui/utils.dart';

class FinishSignUpScreen extends StatefulWidget {
  final String email;
  final String authId;
  const FinishSignUpScreen({
    super.key,
    required this.email,
    required this.authId,
  });

  @override
  State<FinishSignUpScreen> createState() => _FinishSignUpScreenState();
}

class _FinishSignUpScreenState extends State<FinishSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _surname;
  String? _nickname;

  bool get _isFormValid =>
      _name != null &&
      _name!.isNotEmpty &&
      _surname != null &&
      _surname!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [
                  AutofillHints.name,
                  AutofillHints.nickname,
                  AutofillHints.givenName,
                ],
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  return emptyStringValidator(value, 'Please enter a surname');
                },
                maxLength: 20,
                onTapOutside: (t) {
                  _formKey.currentState?.validate();
                },
                onChanged: (v) {
                  _name = v;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [
                  AutofillHints.familyName,
                  AutofillHints.nickname,
                ],
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                ),
                validator: (value) {
                  return emptyStringValidator(value, 'Please enter a surname');
                },
                onTapOutside: (t) {
                  _formKey.currentState?.validate();
                },
                onChanged: (v) {
                  _surname = v;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [
                  AutofillHints.nickname,
                ],
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  hintText: 'This nickname also defines your avatar',
                ),
                onChanged: (v) {
                  _nickname = v;
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              DelayedRebuildWidget(
                child: AvatarLoader(
                  key: ValueKey(_nickname),
                  email: widget.email,
                  nickname: _nickname,
                  size: 120,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isFormValid
                    ? () async {
                        final dto = UserCreationDTO(
                          email: widget.email,
                          name: _name!,
                          surname: _surname!,
                          authId: widget.authId,
                          nickname: _nickname,
                        );
                        showDialog(
                          context: context,
                          builder: (context) => UserCreationLoadingDialog(
                            dto: dto,
                          ),
                        );
                      }
                    : null,
                child: const Text('Finish Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCreationLoadingDialog extends ConsumerWidget {
  final UserCreationDTO dto;
  const UserCreationLoadingDialog({
    super.key,
    required this.dto,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userCreationProvider(dto), (prev, current) {
      if (current.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${current.error.toString()}'),
          ),
        );
        context.pop();
      }
      if (current.hasValue) {
        context.go(AppRoute.home.path());
      }
    });

    return Dialog.fullscreen(
      child: Material(
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
