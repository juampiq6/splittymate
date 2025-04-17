import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splittymate/providers/split_group_provider.dart';
import 'package:splittymate/providers/supabase_service_provider.dart';
import 'package:splittymate/providers/transactions_provider.dart';
import 'package:splittymate/ui/home.dart';
import 'package:splittymate/ui/login/finish_sign_up_screen.dart';
import 'package:splittymate/ui/login/otp_input_screen.dart';
import 'package:splittymate/ui/login/login_home.dart';
import 'package:splittymate/ui/profile/profile_settings.dart';
import 'package:splittymate/ui/splash.dart';
import 'package:splittymate/ui/split_group/settings/invitation/accept_group_invite.dart';
import 'package:splittymate/ui/split_group/new_group_form/new_split_group_form.dart';
import 'package:splittymate/ui/split_group/split_group_balances.dart';
import 'package:splittymate/ui/split_group/split_group_home.dart';
import 'package:splittymate/ui/split_group/settings/split_group_settings.dart';
import 'package:splittymate/ui/transaction/new_expense/new_expense_form.dart';
import 'package:splittymate/ui/transaction/new_payment/new_payment_form.dart';
import 'package:splittymate/ui/transaction/transaction_detail/transaction_detail.dart';

final router = GoRouter(
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
          path: 'otp_input_from_email/:email',
          builder: (context, state) {
            final email = state.pathParameters['email']!;
            final code = state.uri.queryParameters['code'];
            final newUser =
                bool.parse(state.uri.queryParameters['new'] ?? 'false');
            final groupInvitation =
                state.uri.queryParameters['groupInvitation'];
            return OTPInputScreen(
              email: email,
              code: code,
              groupInvitation: groupInvitation,
              newUser: newUser,
            );
          },
        ),
        GoRoute(
          path: 'otp_input/:email',
          builder: (context, state) {
            final email = state.pathParameters['email']!;
            final groupInvitation =
                state.uri.queryParameters['groupInvitation'];
            return OTPInputScreen(
              email: email,
              groupInvitation: groupInvitation,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/finish_sign_up',
      builder: (context, state) {
        final groupInvitation =
            state.uri.queryParameters['group_invitation'] ?? '';
        return Consumer(
          builder: (context, ref, child) {
            final user = ref.watch(supabaseAuthProvider).getLoggedUser();
            return FinishSignUpScreen(
              email: user.email!,
              authId: user.id,
              groupInvitation: groupInvitation,
            );
          },
        );
      },
    ),
    GoRoute(
        path: '/invitation',
        builder: (context, state) {
          final invitationLink = state.uri.queryParameters['link'];
          return AcceptGroupInviteDialog(invitationLink: invitationLink!);
        }),
    GoRoute(
      path: '/',
      builder: (context, state) {
        final groupInvitation = state.uri.queryParameters['groupInvitation'];
        return HomeScreen(groupIdRedirection: groupInvitation);
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
);
