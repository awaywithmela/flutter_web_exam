import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'login_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  static const routeName = '/admin';

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      _usersFuture = UserService().getAllUsers(token);
    } else {
      _usersFuture = Future.error('Not authenticated');
    }
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPage.routeName,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      admin?.email ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Logout',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Could not load users.\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => setState(_loadUsers),
                          style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0F766E)),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                final users = snapshot.data ?? [];
                final adminCount = users.where((u) => u.isAdmin).length;
                final regularCount = users.length - adminCount;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Stat Cards ──────────────────────────────────────
                      Row(
                        children: [
                          _StatCard(
                            label: 'Total Users',
                            value: '${users.length}',
                            gradientColors: const [
                              Color(0xFF0F766E),
                              Color(0xFF0D9488)
                            ],
                          ),
                          const SizedBox(width: 16),
                          _StatCard(
                            label: 'Admins',
                            value: '$adminCount',
                            gradientColors: const [
                              Color(0xFF7C3AED),
                              Color(0xFF9F67FA)
                            ],
                          ),
                          const SizedBox(width: 16),
                          _StatCard(
                            label: 'Regular Users',
                            value: '$regularCount',
                            gradientColors: const [
                              Color(0xFF0284C7),
                              Color(0xFF38BDF8)
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ── Full-Width Table ─────────────────────────────────
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Header
                            const Padding(
                              padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                              child: Text(
                                'Registered Users',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1),

                            // Table — full width using LayoutBuilder
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                    child: DataTable(
                                      showCheckboxColumn: false,
                                      columnSpacing: 24.0,
                                      horizontalMargin: 24.0,
                                      headingRowColor: WidgetStateProperty.all(
                                          const Color(0xFFF8FAFC)),
                                      headingTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                      dataRowMaxHeight: 52,
                                      dividerThickness: 0.8,
                                      columns: const [
                                        DataColumn(label: Text('ID')),
                                        DataColumn(label: Text('Full Name')),
                                        DataColumn(label: Text('Email')),
                                        DataColumn(label: Text('Role')),
                                        DataColumn(label: Text('City')),
                                        DataColumn(label: Text('Country')),
                                        DataColumn(label: Text('Phone')),
                                      ],
                                      rows: users.map((u) {
                                        return DataRow(
                                          onSelectChanged: (selected) {
                                            if (selected ?? false) {
                                              showDialog(
                                                context: context,
                                                builder: (context) => _UserEditDialog(
                                                  user: u,
                                                  onUserUpdated: () => setState(_loadUsers),
                                                ),
                                              );
                                            }
                                          },
                                          cells: [
                                            DataCell(Text('#${u.id}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade500))),
                                          DataCell(Text(u.fullName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600))),
                                          DataCell(Text(u.email,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade700))),
                                          DataCell(
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: u.isAdmin
                                                    ? const Color(0xFFEDE9FE)
                                                    : const Color(0xFFCCFBF1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                u.isAdmin ? 'Admin' : 'User',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: u.isAdmin
                                                      ? const Color(0xFF6D28D9)
                                                      : const Color(0xFF0F766E),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(u.city ?? '—',
                                              style:
                                                  const TextStyle(fontSize: 13))),
                                          DataCell(Text(u.country ?? '—',
                                              style:
                                                  const TextStyle(fontSize: 13))),
                                          DataCell(Text(u.phoneNumber ?? '—',
                                              style:
                                                  const TextStyle(fontSize: 13))),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.gradientColors,
  });

  final String label;
  final String value;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── User Edit Dialog ────────────────────────────────────────────────────────
class _UserEditDialog extends StatefulWidget {
  final UserModel user;
  final VoidCallback onUserUpdated;

  const _UserEditDialog({required this.user, required this.onUserUpdated});

  @override
  State<_UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<_UserEditDialog> {
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _genderController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _middleNameController = TextEditingController(text: widget.user.middleName ?? '');
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _cityController = TextEditingController(text: widget.user.city ?? '');
    _countryController = TextEditingController(text: widget.user.country ?? '');
    _genderController = TextEditingController(text: widget.user.gender ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final token = context.read<AuthProvider>().token;
      if (token == null) return;
      
      final updatedUser = UserModel(
        id: widget.user.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        middleName: _middleNameController.text.trim().isNotEmpty ? _middleNameController.text.trim() : null,
        phoneNumber: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        birthDate: widget.user.birthDate,
        gender: _genderController.text.trim().isNotEmpty ? _genderController.text.trim() : null,
        address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
        city: _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : null,
        country: _countryController.text.trim().isNotEmpty ? _countryController.text.trim() : null,
        profilePictureUrl: widget.user.profilePictureUrl,
        isAdmin: widget.user.isAdmin,
      );

      await UserService().updateUser(token, widget.user.id, updatedUser);
      
      if (mounted) {
        Navigator.pop(context);
        widget.onUserUpdated();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e', style: const TextStyle(color: Colors.white))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update User Details', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _middleNameController, decoration: const InputDecoration(labelText: 'Middle Name', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: _genderController, decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Contact & Location', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
              const SizedBox(height: 12),
              TextField(controller: _emailController, readOnly: true, decoration: const InputDecoration(labelText: 'Email Address (Read-Only)', border: OutlineInputBorder(), filled: true, fillColor: Color(0xFFF1F5F9))),
              const SizedBox(height: 16),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'Street Address', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()))),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
          child: _isLoading 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Save Changes'),
        ),
      ],
    );
  }
}
