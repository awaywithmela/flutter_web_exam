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
          scaffoldBackgroundColor: const Color(0xFF07080D),
          textTheme:
              GoogleFonts.nunitoTextTheme(
                Theme.of(context).textTheme.apply(
                  bodyColor: const Color(0xFFF7F2EA),
                  displayColor: const Color(0xFFF7F2EA),
                ),
              ).copyWith(
                headlineLarge: GoogleFonts.nunito(
                  color: const Color(0xFFF7F2EA),
                  fontWeight: FontWeight.w900,
                  height: 1.04,
                ),
                headlineMedium: GoogleFonts.nunito(
                  color: const Color(0xFFF7F2EA),
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
                titleLarge: GoogleFonts.nunito(
                  color: const Color(0xFFF7F2EA),
                  fontWeight: FontWeight.w800,
                ),
                titleMedium: GoogleFonts.nunito(
                  color: const Color(0xFFEDE4D8),
                  fontWeight: FontWeight.w800,
                ),
                bodyLarge: GoogleFonts.nunito(
                  color: const Color(0xFFCFC7BC),
                  fontWeight: FontWeight.w600,
                ),
                bodyMedium: GoogleFonts.nunito(
                  color: const Color(0xFFCFC7BC),
                  fontWeight: FontWeight.w600,
                ),
              ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC8B6FF),
            brightness: Brightness.dark,
            primary: const Color(0xFFC8B6FF),
            secondary: const Color(0xFF7FFFD4),
            surface: const Color(0xFF11131B),
            error: const Color(0xFFFF6B7A),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF07080D),
            foregroundColor: Color(0xFFF7F2EA),
            centerTitle: false,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF11131B),
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF242735)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF171923),
            labelStyle: const TextStyle(color: Color(0xFFBDB4AA)),
            hintStyle: const TextStyle(color: Color(0xFF8D857D)),
            prefixIconColor: const Color(0xFFC8B6FF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2A2D3B)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2A2D3B)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFC8B6FF),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF6B7A)),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFC8B6FF),
              foregroundColor: const Color(0xFF171022),
              minimumSize: const Size.fromHeight(52),
              textStyle: GoogleFonts.nunito(
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF7FFFD4),
              textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800),
            ),
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Color(0xFF171923),
            contentTextStyle: TextStyle(color: Color(0xFFF7F2EA)),
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
          return auth.user?.isAdmin == true
              ? const AdminPage()
              : const DashboardPage();
        }

        return const LoginPage();
      },
    );
  }
}
