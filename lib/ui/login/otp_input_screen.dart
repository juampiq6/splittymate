import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/providers/user_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/themes.dart';

class OTPInputScreen extends ConsumerStatefulWidget {
  final String email;
  final String? code;
  final bool? newUser;

  const OTPInputScreen({
    super.key,
    required this.email,
    this.code,
    this.newUser,
  });

  @override
  ConsumerState<OTPInputScreen> createState() => _OTPInputScreenState();
}

class _OTPInputScreenState extends ConsumerState<OTPInputScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.code != null) {
        _codeController.text = widget.code!;
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(OTPInputScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      _codeController.text = widget.code!;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 100,
                    ),
                    Text(
                      'Check your email',
                      style: context.tt.displayLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter the 6 digit code sent to your email',
                      style: context.tt.bodyLarge,
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: PinCodeTextField(
                  appContext: context,
                  controller: _codeController,
                  length: 6,
                  autoFocus: true,
                  autoUnfocus: true,
                  beforeTextPaste: (clipboard) {
                    if (clipboard != null &&
                        clipboard.length == 6 &&
                        int.tryParse(clipboard) != null) {
                      return true;
                    }
                    return false;
                  },
                  showCursor: false,
                  cursorColor: context.theme.primaryColor,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    fieldHeight: 55,
                    fieldWidth: 55,
                    activeColor: context.theme.primaryColor,
                    inactiveColor: context.theme.unselectedWidgetColor,
                    selectedColor: context.theme.primaryColor,
                  ),
                  keyboardType: TextInputType.number,
                  onCompleted: (c) {
                    verifyCode(c);
                  },
                  useHapticFeedback: true,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.go(AppRoute.login
                      .path(parameters: {'initialEmail': widget.email}));
                },
                child: const Text('Resend code'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  verifyCode(String code) async {
    showDialog(
      barrierColor: Colors.black54,
      barrierDismissible: false,
      useRootNavigator: false,
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Container(
          color: Colors.black54,
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
    final authProv = ref.read(authProvider.notifier);
    try {
      await authProv.confirmOTP(otp: code, email: widget.email);
      checkNewUserOrRedirectHome();
    } catch (e) {
      if (mounted) {
        context.pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      _codeController.clear();
    }
  }

  Future<void> checkNewUserOrRedirectHome() async {
    bool? newUser = widget.newUser;
    // If the newUser is null, check if the user is new or not
    if (newUser == null) {
      try {
        await ref.read(userProvider.notifier).build();
      } catch (e) {
        if (e is UserNotFoundException) {
          newUser = true;
        }
      }
    } else {
      if (!newUser) {
        // If the user is not new, redirect to the home screen
        if (mounted) {
          context.go(AppRoute.home.path());
        }
      } else {
        // If the user is new, redirect to the finish sign up screen
        if (mounted) {
          context.go(AppRoute.finishSignUp.path());
        }
      }
    }
  }
}
