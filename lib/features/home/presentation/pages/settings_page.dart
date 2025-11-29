import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Update your profile and change advance settings',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSettingItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Profile',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profile page coming soon')),
                      );
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Proscribed Form',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Proscribed Form page coming soon')),
                      );
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Admin Panel',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Admin Panel coming soon')),
                      );
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Update Location',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Update Location page coming soon')),
                      );
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Change Password page coming soon')),
                      );
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    isLogout: true,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isLogout
                ? Colors.red.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isLogout ? Colors.red : AppColors.primary,
          size: 16,
        ),
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
