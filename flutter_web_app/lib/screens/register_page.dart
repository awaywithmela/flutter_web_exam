import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../widgets/auth_shell.dart';
import '../widgets/custom_textfield.dart';
import 'dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return AuthShell(
      title: 'Create account',
      subtitle: 'Register once, then use your JWT-backed profile session.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _firstNameController,
              label: 'First name',
              icon: Icons.person_outline,
              validator: (value) => Validators.required(value, 'First name'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _middleNameController,
              label: 'Middle name',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _lastNameController,
              label: 'Last name',
              icon: Icons.person_outline,
              validator: (value) => Validators.required(value, 'Last name'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              label: 'Phone number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _cityController,
              label: 'City',
              icon: Icons.location_city_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _countryController,
              label: 'Country',
              icon: Icons.public_outlined,
            ),
            if (auth.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                auth.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: auth.isLoading ? null : _register,
              child: auth.isLoading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Register'),
            ),
            TextButton(
              onPressed: auth.isLoading ? null : () => Navigator.pop(context),
              child: const Text('Back to login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final didRegister = await context.read<AuthProvider>().register(
          firstName: _firstNameController.text,
          middleName: _middleNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phoneNumber: _phoneController.text,
          city: _cityController.text,
          country: _countryController.text,
        );

    if (didRegister && mounted) {
      Navigator.pushReplacementNamed(context, DashboardPage.routeName);
    }
  }
}
