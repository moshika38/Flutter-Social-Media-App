import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<UserModel?>(
            future: userProvider.getUserById(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.profilePicture ?? "assets/images/user.jpg"),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
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
                          'Edit Account',
                          Icons.edit_outlined,
                          onTap: () {
                           (context).pushNamed('account');
                          },
                        ),
                        _buildSettingsTile(
                          context,
                          'Privacy & Security',
                          Icons.security_outlined,
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
                      onPressed: () {
                        userProvider.signOut();
                        context.go('/start');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
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

