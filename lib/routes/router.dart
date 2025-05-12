import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/auth_provider.dart';
import 'package:splittymate/providers/invitation_link_provider.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/routes/routes.dart';
import 'package:splittymate/ui/home.dart';
import 'package:splittymate/ui/login/finish_sign_up_screen.dart';
import 'package:splittymate/ui/login/otp_input_screen.dart';
import 'package:splittymate/ui/login/login_home.dart';
import 'package:splittymate/ui/profile/profile_settings.dart';
import 'package:splittymate/ui/splash.dart';
import 'package:splittymate/ui/split_group/new_group_form/new_split_group_form.dart';
import 'package:splittymate/ui/split_group/split_group_balances.dart';
import 'package:splittymate/ui/split_group/split_group_home.dart';
import 'package:splittymate/ui/split_group/settings/split_group_settings.dart';
import 'package:splittymate/ui/transaction/new_expense/new_expense_form.dart';
import 'package:splittymate/ui/transaction/new_payment/new_payment_form.dart';
import 'package:splittymate/ui/transaction/transaction_detail/transaction_detail.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoute.splash.getNestedPath,
    routes: [
      GoRoute(
        path: AppRoute.splash.getNestedPath,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: AppRoute.login.getNestedPath,
        builder: (context, state) {
          return const LoginHome();
        },
        routes: [
          GoRoute(
            path: AppRoute.otpInput.getNestedPath,
            builder: (context, state) {
              final email = state.pathParameters['email']!;
              // Filled in when coming from email link
              final code = state.uri.queryParameters['code'];
              final newUser =
                  bool.tryParse(state.uri.queryParameters['new'] ?? '');
              return OTPInputScreen(
                email: email,
                code: code,
                newUser: newUser,
              );
            },
          ),
          GoRoute(
            path: AppRoute.finishSignUp.getNestedPath,
            builder: (context, state) {
              return Consumer(
                builder: (context, ref, child) {
                  final auth = ref.watch(authProvider);
                  return FinishSignUpScreen(
                    email: auth.email!,
                    authId: auth.authId!,
                  );
                },
              );
            },
          ),
        ],
      ),
      // This route is used to receive the invitation link and save it in a provider
      GoRoute(
        path: AppRoute.join.getNestedPath,
        redirect: (context, state) {
          // The group invitation link is assigned in the provider so it can be used later
          ref.read(groupInvitationProvider.notifier).state =
              state.uri.queryParameters['groupInvitation'];
          return AppRoute.splash.getNestedPath;
        },
      ),
      GoRoute(
        path: AppRoute.home.getNestedPath,
        builder: (context, state) {
          return const HomeScreen();
        },
        routes: [
          GoRoute(
            path: AppRoute.profileSettings.getNestedPath,
            builder: (context, state) {
              return const ProfileSettings();
            },
          ),
          GoRoute(
            path: AppRoute.splitGroupSettings.getNestedPath,
            builder: (context, state) {
              final groupId = state.pathParameters['groupSettingsId']!;
              return SplitGroupSettings(groupId: groupId);
            },
          ),
          GoRoute(
            path: AppRoute.newSplitGroup.getNestedPath,
            builder: (context, state) {
              return const NewSplitGroupForm();
            },
          ),
          GoRoute(
            path: AppRoute.splitGroupHome.getNestedPath,
            builder: (context, state) {
              final groupId = state.pathParameters['groupId']!;
              return Consumer(
                builder: (context, ref, child) => SplitGroupHome(
                  group: ref.watch(splitGroupProvider(groupId)),
                ),
              );
            },
            routes: [
              GoRoute(
                path: AppRoute.newExpenseForm.getNestedPath,
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId']!;
                  return Consumer(
                    builder: (context, ref, child) => NewExpenseForm(
                      splitGroup: ref.watch(splitGroupProvider(groupId)),
                    ),
                  );
                },
              ),
              GoRoute(
                path: AppRoute.newPaymentForm.getNestedPath,
                builder: (context, state) {
                  return Consumer(
                    builder: (context, ref, child) {
                      final groupId = state.pathParameters['groupId']!;
                      return NewPaymentForm(
                        splitGroup: ref.watch(splitGroupProvider(groupId)),
                      );
                    },
                  );
                },
              ),
              GoRoute(
                path: AppRoute.transactionDetail.getNestedPath,
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId']!;
                  final txId = state.pathParameters['txId'];
                  return Consumer(
                    builder: (context, ref, child) => ExpenseDetail(
                      expense: ref
                          .watch(transactionProvider(groupId))
                          .firstWhere((t) => t.id == txId),
                    ),
                  );
                },
              ),
              GoRoute(
                path: AppRoute.splitGroupBalances.getNestedPath,
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId']!;
                  return Consumer(
                    builder: (context, ref, child) => SplitGroupBalances(
                      group: ref.watch(splitGroupProvider(groupId)),
                    ),
                  );
                },
              ),
              GoRoute(
                path: AppRoute.splitGroupSettings.getNestedPath,
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId']!;
                  return SplitGroupSettings(groupId: groupId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);
