import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../widgets/custom_textfield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _genderController = TextEditingController();
  final _photoController = TextEditingController();
  UserModel? _loadedUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.watch<AuthProvider>().user;
    if (user != null && user.id != _loadedUser?.id) {
      _loadedUser = user;
      _firstNameController.text = user.firstName;
      _middleNameController.text = user.middleName ?? '';
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phoneNumber ?? '';
      _addressController.text = user.address ?? '';
      _cityController.text = user.city ?? '';
      _countryController.text = user.country ?? '';
      _genderController.text = user.gender ?? '';
      _photoController.text = user.profilePictureUrl ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _genderController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No active profile')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: const Color(0xFF11131B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF2A2D3B)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: const Color(0xFFC8B6FF),
                          child: Text(
                            user.firstName.isEmpty
                                ? '?'
                                : user.firstName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF171022),
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF11131B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF2A2D3B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Personal details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 18),
                        _FieldGrid(
                          children: [
                            CustomTextField(
                              controller: _firstNameController,
                              label: 'First name',
                              icon: Icons.person_outline,
                              validator: (value) =>
                                  Validators.required(value, 'First name'),
                            ),
                            CustomTextField(
                              controller: _middleNameController,
                              label: 'Middle name',
                              icon: Icons.badge_outlined,
                            ),
                            CustomTextField(
                              controller: _lastNameController,
                              label: 'Last name',
                              icon: Icons.person_outline,
                              validator: (value) =>
                                  Validators.required(value, 'Last name'),
                            ),
                            CustomTextField(
                              controller: _phoneController,
                              label: 'Phone number',
                              icon: Icons.phone_outlined,
                            ),
                            CustomTextField(
                              controller: _genderController,
                              label: 'Gender',
                              icon: Icons.wc_outlined,
                            ),
                            CustomTextField(
                              controller: _addressController,
                              label: 'Address',
                              icon: Icons.home_outlined,
                            ),
                            CustomTextField(
                              controller: _cityController,
                              label: 'City',
                              icon: Icons.location_city_outlined,
                            ),
                            CustomTextField(
                              controller: _countryController,
                              label: 'Country',
                              icon: Icons.public_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _photoController,
                          label: 'Profile picture URL',
                          icon: Icons.image_outlined,
                        ),
                        if (auth.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            auth.errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: auth.isLoading ? null : () => _save(user),
                          icon: const Icon(Icons.save_outlined),
                          label: auth.isLoading
                              ? const Text('Saving...')
                              : const Text('Save profile'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(UserModel user) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedUser = UserModel(
      id: user.id,
      firstName: _firstNameController.text.trim(),
      middleName: _emptyToNull(_middleNameController.text),
      lastName: _lastNameController.text.trim(),
      email: user.email,
      phoneNumber: _emptyToNull(_phoneController.text),
      birthDate: user.birthDate,
      gender: _emptyToNull(_genderController.text),
      address: _emptyToNull(_addressController.text),
      city: _emptyToNull(_cityController.text),
      country: _emptyToNull(_countryController.text),
      profilePictureUrl: _emptyToNull(_photoController.text),
      isAdmin: user.isAdmin,
    );

    final didSave = await context.read<AuthProvider>().updateProfile(
      updatedUser,
    );

    if (didSave && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    }
  }

  String? _emptyToNull(String value) {
    if (value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }
}

class _FieldGrid extends StatelessWidget {
  const _FieldGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: children
              .map(
                (child) => SizedBox(
                  width: isWide
                      ? (constraints.maxWidth - 14) / 2
                      : constraints.maxWidth,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
