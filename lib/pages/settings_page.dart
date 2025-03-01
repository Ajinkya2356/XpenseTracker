import 'package:flutter/material.dart';
import '../config/theme_config.dart';
import 'edit_profile_page.dart'; // Make sure to add this import

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String selectedCurrency = '₹'; // Add this line
  String selectedCurrencyName = 'Indian Rupee'; // Add this line

  final List<Map<String, String>> currencies = [ // Add currency list
    {'symbol': '₹', 'name': 'Indian Rupee', 'code': 'INR'},
    {'symbol': '\$', 'name': 'US Dollar', 'code': 'USD'},
    {'symbol': '€', 'name': 'Euro', 'code': 'EUR'},
    {'symbol': '£', 'name': 'British Pound', 'code': 'GBP'},
    {'symbol': '¥', 'name': 'Japanese Yen', 'code': 'JPY'},
    {'symbol': '₿', 'name': 'Bitcoin', 'code': 'BTC'},
  ];

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeConfig.darkColor, // Changed from gradient to solid color
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: ThemeConfig.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Logo and Version
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ThemeConfig.primaryColor.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeConfig.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 48,
                        color: ThemeConfig.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Xpense',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Features List
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureItem(
                      icon: Icons.track_changes,
                      title: 'Expense Tracking',
                      description: 'Track your daily expenses with ease',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      icon: Icons.category,
                      title: 'Categories',
                      description: 'Organize expenses by categories',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      icon: Icons.insights,
                      title: 'Analytics',
                      description: 'View detailed spending insights',
                    ),
                  ],
                ),
              ),
              
              // Close Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: ThemeConfig.primaryColor,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ThemeConfig.darkColor, // Already using correct color
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: ThemeConfig.expenseRed.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeConfig.expenseRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout,
                  color: ThemeConfig.expenseRed,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to sign out?',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        // Handle sign out
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: ThemeConfig.expenseRed,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeConfig.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: ThemeConfig.primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: ThemeConfig.surfaceColor,
      // Use default icon if image fails to load
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile.jpg',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: 50,
              color: ThemeConfig.primaryColor,
            );
          },
        ),
      ),
    );
  }

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
          // Profile Card
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileImage(),
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
                    onPressed: _showEditProfile,
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Settings List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _buildSettingCard(
                    title: 'Currency',
                    subtitle: '$selectedCurrencyName ($selectedCurrency)',
                    icon: Icons.currency_exchange,
                    color: Colors.green,
                    onTap: () => _showCurrencyPicker(context),
                  );
                case 1:
                  return _buildSettingCard(
                    title: 'Notifications',
                    subtitle: notificationsEnabled ? 'Notifications are enabled' : 'Notifications are disabled',
                    icon: Icons.notifications_active,
                    color: notificationsEnabled ? Colors.orange : Colors.grey,
                    onTap: () {
                      setState(() => notificationsEnabled = !notificationsEnabled);
                    },
                    trailing: Switch(
                      value: notificationsEnabled,
                      onChanged: (value) => setState(() => notificationsEnabled = value),
                      activeColor: ThemeConfig.primaryColor,
                      activeTrackColor: ThemeConfig.primaryColor.withOpacity(0.3),
                      inactiveThumbColor: Colors.grey[400],
                      inactiveTrackColor: ThemeConfig.surfaceColor,
                      trackOutlineColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.selected)
                            ? Colors.transparent
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  );
                case 2:
                  return _buildSettingCard(
                    title: 'About App',
                    subtitle: 'Version 1.0.0',
                    icon: Icons.info_outline,
                    color: Colors.blue,
                    onTap: _showAboutDialog,
                  );
                case 3:
                  return _buildSettingCard(
                    title: 'Clear All Data',
                    subtitle: 'Remove all expenses and settings',
                    icon: Icons.delete_outline,
                    color: ThemeConfig.expenseRed,
                    onTap: () => _showDeleteConfirmation(context),
                  );
                case 4:
                  return _buildSettingCard(
                    title: 'Sign Out',
                    subtitle: 'Log out from your account',
                    icon: Icons.logout,
                    color: ThemeConfig.expenseRed,
                    onTap: _showSignOutConfirmation,
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.grey.withOpacity(0.1),
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
      elevation: 0,
      margin: EdgeInsets.zero,
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
        backgroundColor: ThemeConfig.darkColor, // Already using correct color
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

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeConfig.darkColor, // Changed from surfaceColor
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bottom sheet handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            const Text(
              'Select Currency',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Currency List
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency['symbol'] == selectedCurrency;
                  
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          selectedCurrency = currency['symbol']!;
                          selectedCurrencyName = currency['name']!;
                        });
                        Navigator.pop(context);
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeConfig.primaryColor.withOpacity(0.2)
                              : ThemeConfig.darkBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          currency['symbol']!,
                          style: TextStyle(
                            fontSize: 18,
                            color: isSelected
                                ? ThemeConfig.primaryColor
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        currency['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        currency['code']!,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: ThemeConfig.primaryColor,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}