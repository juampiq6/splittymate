import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/ui/themes.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({super.key});

  @override
  LoginHomeState createState() => LoginHomeState();
}

// TODO add 60 seconds counter to resend email
class LoginHomeState extends State<LoginHome> {
  final _formKey = GlobalKey<FormState>();
  bool _emailIsValid = false;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SizedBox(
          height: 100,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Text(
                  'SPLITTYMATE',
                  style: context.tt.displayLarge,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [
                  AutofillHints.email,
                ],
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onTapOutside: (t) {
                  _formKey.currentState!.validate();
                },
                onSaved: (newValue) {
                  _email = newValue!;
                },
                onChanged: (v) {
                  final valid = isValidEmail(v);
                  if (valid != _emailIsValid) {
                    _emailIsValid = valid;
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: !_emailIsValid
                        ? null
                        : () async {
                            _formKey.currentState!.save();
                            final prov = ref.read(supabaseAuthProvider);
                            try {
                              await prov.magicLinkLogin(_email!);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString(),
                                    ),
                                  ),
                                );
                                return;
                              }
                            }
                            if (context.mounted) {
                              navigateCheckEmailScreen(context, _email!);
                            }
                          },
                    child: const Text('Continue'),
                  );
                },
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  navigateCheckEmailScreen(BuildContext context, String email) async {
    context.go('/login/otp_input/$email');
  }
}
