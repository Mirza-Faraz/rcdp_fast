import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class ApprovalSubmissionPage extends StatelessWidget {
  final String clientName;
  final String clientId;

  const ApprovalSubmissionPage({
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
          'Approval Submission',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Approval Submission Form',
          style: TextStyle(fontSize: 18, color: AppColors.primary),
        ),
      ),
    );
  }
}



