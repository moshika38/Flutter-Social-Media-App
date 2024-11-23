import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john.doe@example.com',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings List
              _buildSettingsSection(
                context,
                'Account Settings',
                [
                  _buildSettingsTile(
                    context,
                    'Personal Information',
                    Icons.person_outline,
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    context,
                    'Privacy & Security',
                    Icons.security_outlined,
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    context,
                    'Edit Account',
                    Icons.edit_outlined,
                    onTap: () {},
                  ),
                ],
              ),
              _buildSettingsSection(
                context,
                'App Settings',
                [
                  _buildSettingsTile(
                    context,
                    'Language',
                    Icons.language_outlined,
                    trailing: const Text('English'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.dark_mode_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: const Text('Switch to Light Mode'),
                    trailing: const SizedBox.shrink(),
                  ),
                ],
              ),
              _buildSettingsSection(
                context,
                'Support',
                [
                  _buildSettingsTile(
                    context,
                    'Help Center',
                    Icons.help_outline,
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    context,
                    'Terms of Service',
                    Icons.description_outlined,
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    context,
                    'Privacy Policy',
                    Icons.privacy_tip_outlined,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> tiles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...tiles,
        const Divider(),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
