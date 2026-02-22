import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/pin_setup_page.dart';
import '../../features/auth/presentation/pages/pin_login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/wallets/presentation/pages/wallets_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/wallets/presentation/screens/create_wallet_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../../features/profile/presentation/pages/fixed_expenses_page.dart';
import '../../core/di/injection_container.dart';
import '../../features/auth/data/auth_repository.dart';
import '../presentation/pages/main_container.dart';
import '../presentation/pages/splash_page.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final authRepo = sl<AuthRepository>();
    final isFirstTime = authRepo.isFirstTime;
    final isAuthenticated = authRepo.isAuthenticated;

    if (state.uri.toString() == '/splash') return null;

    if (isFirstTime) {
      if (state.uri.toString() != '/setup-pin') return '/setup-pin';
      return null;
    }

    if (!isAuthenticated) {
      if (state.uri.toString() != '/pin-login') return '/pin-login';
      return null;
    }

    if (isAuthenticated && state.uri.toString() == '/pin-login') {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/setup-pin',
      builder: (context, state) => const PinSetupPage(),
    ),
    GoRoute(
      path: '/pin-login',
      builder: (context, state) => const PinLoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainContainer(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsPage(),
        ),
        GoRoute(
          path: '/wallets',
          builder: (context, state) => const WalletsPage(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/create-wallet',
      builder: (context, state) => const CreateWalletScreen(),
    ),
    GoRoute(
      path: '/add-transaction',
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '/fixed-expenses',
      builder: (context, state) => const FixedExpensesPage(),
    ),
  ],
);
