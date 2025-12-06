import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.primary,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Update your profile and change advance settings',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildInfoField('Name', 'Khalid Test'),
            const SizedBox(height: 24),
            _buildInfoField('Branches', 'Lahore 2'),
            const SizedBox(height: 24),
            _buildInfoField('Phone', '-'),
            const SizedBox(height: 24),
            _buildInfoField('Email', '-'),
            const SizedBox(height: 24),
            _buildInfoField('Accounts Expiry Date', '01/01/2026 00:00:00'),
            const SizedBox(height: 24),
            _buildInfoField('Designation', 'Credit Officer'),
            const SizedBox(height: 24),
            _buildInfoField('Rights Group', 'Credit Officer Group'),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle update
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.isEmpty ? '' : value,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
