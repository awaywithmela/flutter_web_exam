import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/admin_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/login_page.dart';
import 'screens/profile_page.dart';
import 'screens/register_page.dart';
import 'widgets/loading_widget.dart';

void main() {
  runApp(const PortfolioAuthApp());
}

class PortfolioAuthApp extends StatelessWidget {
  const PortfolioAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..bootstrap(),
      child: MaterialApp(
        title: 'Portfolio Auth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        routes: {
          LoginPage.routeName: (_) => const LoginPage(),
          RegisterPage.routeName: (_) => const RegisterPage(),
          DashboardPage.routeName: (_) => const DashboardPage(),
          ProfilePage.routeName: (_) => const ProfilePage(),
          AdminPage.routeName: (_) => const AdminPage(),
        },
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isBootstrapping) {
          return const LoadingWidget();
        }

        if (auth.isAuthenticated) {
          return auth.user?.isAdmin == true ? const AdminPage() : const DashboardPage();
        }
        
        return const LoginPage();
      },
    );
  }
}
