import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/themes.dart';
import 'package:splittymate/ui/utils.dart';

class LoginHome extends StatefulWidget {
  final String? initialEmail;
  const LoginHome({super.key, this.initialEmail});

  @override
  LoginHomeState createState() => LoginHomeState();
}

class LoginHomeState extends State<LoginHome> {
  final _formKey = GlobalKey<FormState>();
  bool _formIsValid = false;
  String? _email;
  bool submitting = false;

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _email = widget.initialEmail;
  }

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
                    padding: const EdgeInsets.all(2),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      style: context.theme.iconButtonTheme.style!.copyWith(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.lightWhite),
                        foregroundColor:
                            WidgetStateProperty.all(AppColors.primary),
                      ),
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
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
                  _formIsValid = _formKey.currentState!.validate();
                  setState(() {});
                },
                onFieldSubmitted: (value) {
                  _formIsValid = _formKey.currentState!.validate();
                  setState(() {});
                },
                onSaved: (newValue) {
                  _email = newValue!;
                },
              ),
              const Expanded(child: SizedBox()),
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: !_formIsValid || submitting
                        ? null
                        : () => onSubmit(ref.read(authProvider.notifier)),
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

  Future<void> onSubmit(AuthProvider prov) async {
    _formKey.currentState!.save();
    submitting = true;
    setState(() {});
    try {
      await prov.magicLinkLogin(_email!);
    } catch (e) {
      if (mounted) {
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
    if (mounted) {
      context.go(AppRoute.otpInput.path(parameters: {'email': _email!}));
    }
  }
}
