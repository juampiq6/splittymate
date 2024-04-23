import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/models/dto/user_creation_dto.dart';
import 'package:splittymate/providers/user_creation_provider.dart';

// TODO add photo upload
class FinishSignUpScreen extends StatefulWidget {
  final String email;
  final String authId;
  final String groupInvitation;
  const FinishSignUpScreen({
    super.key,
    required this.email,
    required this.authId,
    required this.groupInvitation,
  });

  @override
  State<FinishSignUpScreen> createState() => _FinishSignUpScreenState();
}

class _FinishSignUpScreenState extends State<FinishSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _surname;
  String? _photoUri;
  // bool _loading = false;

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
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
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
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofillHints: const [
                AutofillHints.familyName,
                AutofillHints.nickname,
              ],
              decoration: const InputDecoration(
                labelText: 'Surname',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a surname';
                }
                return null;
              },
              onTapOutside: (t) {
                _formKey.currentState?.validate();
              },
              onChanged: (v) {
                _surname = v;
                setState(() {});
              },
            ),
            ElevatedButton(
              onPressed: _isFormValid
                  ? () async {
                      final dto = UserCreationDTO(
                        email: widget.email,
                        name: _name!,
                        surname: _surname!,
                        photoUrl: _photoUri,
                        authId: widget.authId,
                      );
                      showDialog(
                        context: context,
                        builder: (context) => UserCreationLoadingDialog(
                          dto: dto,
                          groupInvitation: widget.groupInvitation,
                        ),
                      );
                    }
                  : null,
              child: const Text('Finish Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCreationLoadingDialog extends ConsumerWidget {
  final UserCreationDTO dto;
  final String groupInvitation;
  const UserCreationLoadingDialog(
      {super.key, required this.dto, required this.groupInvitation});

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
        context.go('/$groupInvitation');
      }
    });

    return Dialog.fullscreen(
      child: Material(
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
