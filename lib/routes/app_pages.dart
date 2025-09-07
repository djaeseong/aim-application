import 'package:aim_application/presentation/login/login_screen.dart';
import 'package:aim_application/presentation/main/main_screen.dart';
import 'package:aim_application/presentation/sign_up/sign_up_screen.dart';
import 'package:aim_application/presentation/splash/splash_screen.dart';
import 'package:aim_application/presentation/stock_detail/stock_detail_screen.dart';
import 'package:aim_application/routes/router_observer.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashScreen.route,
  observers: [RouterObserver()],
  routes: [
    GoRoute(name: SplashScreen.route, path: SplashScreen.route, builder: (context, state) => const SplashScreen()),
    GoRoute(name: LoginScreen.route, path: LoginScreen.route, builder: (context, state) => const LoginScreen()),
    GoRoute(name: SignUpScreen.route, path: SignUpScreen.route, builder: (context, state) => const SignUpScreen()),
    GoRoute(name: MainScreen.route, path: MainScreen.route, builder: (context, state) => const MainScreen()),
    GoRoute(
      name: StockDetailScreen.route,
      path: StockDetailScreen.route,
      builder: (context, state) => const StockDetailScreen(),
    ),
  ],
);
