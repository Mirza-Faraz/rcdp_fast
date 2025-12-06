import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class HouseholdAssetsPage extends StatelessWidget {
  final String clientName;
  final String clientId;

  const HouseholdAssetsPage({
    super.key,
    required this.clientName,
    required this.clientId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Household Assets, Livestock & CashFlow',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Household Assets, Livestock & CashFlow Form',
          style: TextStyle(fontSize: 18, color: AppColors.primary),
        ),
      ),
    );
  }
}



