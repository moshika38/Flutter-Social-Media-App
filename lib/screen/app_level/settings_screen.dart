import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_app_flutter/models/user_model.dart';
import 'package:test_app_flutter/providers/theme_provider.dart';
import 'package:test_app_flutter/providers/user_provider.dart';
import 'package:test_app_flutter/utils/app_url.dart';
import 'package:test_app_flutter/widget/progress_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<UserModel?>(
              future: userProvider
                  .getUserById(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProgressBar();
                }

                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                user.profilePicture != ""
                                    ? user.profilePicture!
                                    : AppUrl.baseUserUrl,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
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
                              (context).pushNamed(
                                'account',
                                extra: FirebaseAuth.instance.currentUser!.uid,
                              );
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
                          GestureDetector(
                            onTap: () {
                              themeProvider
                                  .toggleTheme(!themeProvider.isDarkMode);
                            },
                            child: ListTile(
                              leading: Icon(
                                themeProvider.isDarkMode
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              title: Text(themeProvider.isDarkMode
                                  ? 'Switch to Light Mode'
                                  : 'Switch to Dark Mode'),
                              trailing: const SizedBox.shrink(),
                            ),
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
                  return const CircularProgressIndicator();
                }
              },
            ),
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
