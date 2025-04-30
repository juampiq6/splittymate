import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/invitation_link_provider.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/providers/transactions_provider.dart';
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
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginHome();
        },
        routes: [
          GoRoute(
            path: 'otp_input/:email',
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
            path: 'finish_sign_up',
            builder: (context, state) {
              return Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(supabaseAuthProvider).getLoggedUser();
                  return FinishSignUpScreen(
                    email: user.email!,
                    authId: user.id,
                  );
                },
              );
            },
          ),
        ],
      ),
      // This route is used to receive the invitation link and save it in a provider
      GoRoute(
        path: '/join',
        redirect: (context, state) {
          // The group invitation link is assigned in the provider so it can be used later
          ref.read(groupInvitationProvider.notifier).state =
              state.uri.queryParameters['groupInvitation'];
          return '/splash';
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomeScreen();
        },
        routes: [
          GoRoute(
            path: 'profile_settings',
            builder: (context, state) {
              return const ProfileSettings();
            },
          ),
          GoRoute(
            path: 'split_group/new',
            builder: (context, state) {
              return const NewSplitGroupForm();
            },
          ),
          GoRoute(
            path: 'split_group_settings/:groupId',
            builder: (context, state) {
              final groupId = state.pathParameters['groupId']!;
              return SplitGroupSettings(groupId: groupId);
            },
          ),
          GoRoute(
            path: 'split_group/:groupId',
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
                path: 'new_expense',
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
                path: 'new_payment',
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
                path: 'expense_detail/:txId',
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
                path: 'balances',
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
                path: 'settings',
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
