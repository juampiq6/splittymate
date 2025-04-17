import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/utils.dart';

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
  bool submitting = false;

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
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'SPLITTYMATE',
                    style: context.tt.displayLarge,
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [
                  AutofillHints.email,
                ],
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const SizedBox(
                    width: 38,
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      icon: Icon(
                        Icons.cancel_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
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
              const Expanded(child: SizedBox()),
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: !_emailIsValid || submitting
                        ? null
                        : () async {
                            _formKey.currentState!.save();
                            final prov = ref.read(supabaseAuthProvider);
                            try {
                              submitting = true;
                              setState(() {});
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
                            } finally {
                              submitting = false;
                              setState(() {});
                            }
                            if (context.mounted) {
                              navigateCheckEmailScreen(context, _email!);
                            }
                          },
                    child: const Text('Continue'),
                  );
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  navigateCheckEmailScreen(BuildContext context, String email) async {
    context.go('/login/otp_input/$email');
  }
}
