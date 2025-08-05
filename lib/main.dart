import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart'; 
import 'package:rekbro/features/auth/presentation/screens/auth_screen.dart';
import 'package:rekbro/features/home/presentation/screens/home_screen.dart';
import 'package:rekbro/features/verify/presentation/screens/verify_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: const MyApp()));
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const AuthScreen();
      },
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) {
        final link = state.uri.toString();
        return VerifyScreen(link: link);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return HomeScreen();
      },
    ),
  ],
  initialLocation: '/login',
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
    );
  }
}
