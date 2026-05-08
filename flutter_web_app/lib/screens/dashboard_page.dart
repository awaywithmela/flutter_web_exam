import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'login_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, ProfilePage.routeName),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginPage.routeName,
                  (_) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${user?.firstName ?? 'there'}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your protected profile is loaded from the ASP.NET Core API.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  child: ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: Text(user?.fullName ?? 'Authenticated user'),
                    subtitle: Text(user?.email ?? ''),
                    trailing: const Icon(Icons.edit),
                    onTap: () => Navigator.pushNamed(context, ProfilePage.routeName),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'User Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInfoRow('Full Name', user?.fullName ?? '-'),
                        const Divider(),
                        _buildInfoRow('Email', user?.email ?? '-'),
                        const Divider(),
                        _buildInfoRow('Phone', user?.phoneNumber ?? '-'),
                        const Divider(),
                        _buildInfoRow('Gender', user?.gender ?? '-'),
                        const Divider(),
                        _buildInfoRow('Address', user?.address ?? '-'),
                        const Divider(),
                        _buildInfoRow('City', user?.city ?? '-'),
                        const Divider(),
                        _buildInfoRow('Country', user?.country ?? '-'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
