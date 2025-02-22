import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: ThemeConfig.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 50,
                color: ThemeConfig.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              'john.doe@example.com',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 32),

          // Quick Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('Monthly Budget', '₹50,000', ThemeConfig.primaryColor),
              _buildStatCard('Total Expenses', '₹32,450', ThemeConfig.expenseRed),
              _buildStatCard('Savings', '₹17,550', Colors.green),
            ],
          ),
          const SizedBox(height: 32),

          // Profile Options
          _buildProfileOption(
            icon: Icons.wallet,
            title: 'Payment Methods',
            subtitle: 'Manage your payment options',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.history,
            title: 'Transaction History',
            subtitle: 'View all your transactions',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.security,
            title: 'Security',
            subtitle: 'Change password and security settings',
            onTap: () {},
          ),
          _buildProfileOption(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
