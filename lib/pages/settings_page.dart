import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/theme_config.dart';
import 'edit_profile_page.dart'; // Make sure to add this import
import '../services/user_settings_service.dart';
import '../services/upi_service.dart';
import 'package:installed_apps/app_info.dart';
import '../widgets/upi_app_setting_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;
  final _supabase = Supabase.instance.client;
  List<AppInfo> _installedUpiApps = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUpiApps();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        _userProfile = response;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUpiApps() async {
    try {
      debugPrint('Loading UPI apps...');
      final apps = await UpiService.getInstalledUpiApps();
      debugPrint('Loaded ${apps.length} UPI apps');
      if (mounted) {
        setState(() => _installedUpiApps = apps);
      }
    } catch (e) {
      debugPrint('Error loading UPI apps: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading UPI apps: $e')),
        );
      }
    }
  }

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
      child: _userProfile?['profile_image_url'] != null
          ? ClipOval(
              child: Image.network(
                _userProfile!['profile_image_url'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person, size: 50, color: ThemeConfig.primaryColor),
              ),
            )
          : Icon(Icons.person, size: 50, color: ThemeConfig.primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userSettings = Provider.of<UserSettings>(context);
    
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                        Text(
                          _userProfile?['full_name'] ?? 'No Name',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _userProfile?['email'] ?? 'No Email',
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
                  itemCount: 4, // Reduced from 6 to 4 items
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        // Currency Setting
                        final currentCurrency = currencies.firstWhere(
                          (c) => c['code'] == userSettings.currencyCode,
                          orElse: () => currencies.first,
                        );
                        return _buildSettingCard(
                          title: 'Currency',
                          subtitle: '${currentCurrency['name']} (${currentCurrency['symbol']})',
                          icon: Icons.currency_exchange,
                          color: Colors.green,
                          onTap: () => _showCurrencyPicker(context),
                        );
                      case 1:
                        // UPI App Setting
                        return UpiAppSettingCard(
                          onTap: () => _showUpiAppPicker(context),
                        );
                      case 2:
                        // About App
                        return _buildSettingCard(
                          title: 'About App',
                          subtitle: 'Version 1.0.0',
                          icon: Icons.info_outline,
                          color: Colors.blue,
                          onTap: _showAboutDialog,
                        );
                      case 3:
                        // Sign Out
                        return _buildSettingCard(
                          title: 'Sign Out',
                          subtitle: 'Log out from your account',
                          icon: Icons.logout,
                          color: ThemeConfig.expenseRed,
                          onTap: () async {
                            await authService.signOut();
                            if (mounted) {
                              Navigator.of(context).pushReplacementNamed('/login');
                            }
                          },
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),

                // Disabled Features Notice
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Notifications and data management features coming soon!',
                          style: TextStyle(
                            color: Colors.amber[600],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
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
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeConfig.darkColor,
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
                  final isSelected = currency['code'] == userSettings.currencyCode;
                  
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      onTap: () async {
                        try {
                          await userSettings.updateCurrency(
                            currency['code']!,
                            currency['symbol']!,
                          );
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Currency updated successfully')),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error updating currency: $e')),
                            );
                          }
                        }
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

  void _showUpiAppPicker(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeConfig.darkColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Select Default UPI App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _installedUpiApps.length,
                itemBuilder: (context, index) {
                  final app = _installedUpiApps[index];
                  final isSelected = userSettings.defaultUpiApp == app.packageName;
                  
                  return ListTile(
                    onTap: () async {
                      await userSettings.updateDefaultUpiApp(app.packageName);
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Default UPI app set to ${UpiService.getAppDisplayName(app.packageName)}'
                            ),
                          ),
                        );
                      }
                    },
                    leading: Image.memory(
                      app.icon!,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(
                      UpiService.getAppDisplayName(app.packageName),
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: ThemeConfig.primaryColor,
                          )
                        : null,
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