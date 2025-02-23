import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ThemeConfig.appBarColor,
                ThemeConfig.darkestBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: ThemeConfig.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.edit, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'john.doe@example.com',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Budget Settings
          _buildSectionHeader('Budget Settings'),
          _buildSettingCard(
            title: 'Monthly Budget',
            subtitle: '₹50,000',
            icon: Icons.account_balance_wallet,
            color: ThemeConfig.primaryColor,
            onTap: () {},
          ),
          _buildSettingCard(
            title: 'Category Limits',
            subtitle: 'Set spending limits by category',
            icon: Icons.pie_chart,
            color: Colors.purple,
            onTap: () {},
          ),

          // Preferences
          _buildSectionHeader('Preferences'),
          _buildSettingCard(
            title: 'Currency',
            subtitle: 'Indian Rupee (₹)',
            icon: Icons.currency_rupee,
            color: Colors.green,
            onTap: () {},
          ),
          _buildSettingCard(
            title: 'Notifications',
            subtitle: 'Budget alerts & reminders',
            icon: Icons.notifications_active,
            color: Colors.orange,
            onTap: () {},
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          _buildSettingCard(
            title: 'Appearance',
            subtitle: 'Dark theme',
            icon: Icons.dark_mode,
            color: Colors.indigo,
            onTap: () {},
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),

          // Data & Privacy
          _buildSectionHeader('Data & Privacy'),
          _buildSettingCard(
            title: 'Export Data',
            subtitle: 'Download your expense history',
            icon: Icons.download,
            color: Colors.teal,
            onTap: () {},
          ),
          _buildSettingCard(
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            icon: Icons.privacy_tip,
            color: Colors.red,
            onTap: () {},
          ),

          // Support & About
          _buildSectionHeader('Support & About'),
          _buildSettingCard(
            title: 'Help & Support',
            subtitle: 'FAQ and contact support',
            icon: Icons.help,
            color: Colors.amber,
            onTap: () {},
          ),
          _buildSettingCard(
            title: 'About App',
            subtitle: 'Version 1.0.0',
            icon: Icons.info,
            color: Colors.blue,
            onTap: () {},
          ),

          // Danger Zone
          _buildSectionHeader('Danger Zone', color: ThemeConfig.expenseRed),
          _buildSettingCard(
            title: 'Clear All Data',
            subtitle: 'Remove all expenses and settings',
            icon: Icons.delete_forever,
            color: ThemeConfig.expenseRed,
            onTap: () => _showDeleteConfirmation(context),
          ),
          _buildSettingCard(
            title: 'Sign Out',
            subtitle: 'Log out from your account',
            icon: Icons.logout,
            color: ThemeConfig.expenseRed,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_right),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This action cannot be undone. All your expenses, categories, and settings will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(
              backgroundColor: ThemeConfig.expenseRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
