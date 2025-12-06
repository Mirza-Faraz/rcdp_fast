import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'client_forms/basic_client_info_page.dart';
import 'client_forms/group_formation_page.dart';
import 'client_forms/loan_formation_page.dart';
import 'client_forms/client_business_info_page.dart';
import 'client_forms/domestic_income_page.dart';
import 'client_forms/household_facilities_page.dart';
import 'client_forms/household_assets_page.dart';
import 'client_forms/loan_utilizer_info_page.dart';
import 'client_forms/guarantor_info_page.dart';
import 'client_forms/attachments_page.dart';
import 'client_forms/loan_submission_page.dart';
import 'client_forms/approval_submission_page.dart';

class ClientDetailPage extends StatelessWidget {
  final String? cnic;
  final String? memberId;
  final String clientName;

  const ClientDetailPage({super.key, this.cnic, this.memberId, required this.clientName});

  @override
  Widget build(BuildContext context) {
    final displayId = cnic ?? memberId ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [_buildClientInfo(clientName, displayId), const SizedBox(height: 24), _buildMenuItems(context, clientName, displayId)]),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Client Details',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfo(String name, String id) {
    return Column(
      children: [
        Text(
          name.toUpperCase(),
          style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('CNIC', style: TextStyle(color: AppColors.primary, fontSize: 14)),
        const SizedBox(height: 4),
        Text(id, style: const TextStyle(color: AppColors.primary, fontSize: 16)),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context, String clientName, String clientId) {
    final menuItems = [
      _MenuItemData(icon: Icons.info_outline, title: 'Basic Client Information', route: 'basic_client_info', iconColor: Colors.blue),
      _MenuItemData(icon: Icons.group, title: 'Group Formation', route: 'group_formation', iconColor: Colors.purple),
      _MenuItemData(icon: Icons.description, title: 'Loan Formation Information', route: 'loan_formation', iconColor: Colors.indigo),
      _MenuItemData(icon: Icons.business_center, title: 'Client Business Information', route: 'client_business_info', iconColor: Colors.brown),
      _MenuItemData(icon: Icons.home, title: 'Details of Domestic Income', route: 'domestic_income', iconColor: Colors.green),
      _MenuItemData(icon: Icons.local_hospital, title: 'Household Facilities and Health Status', route: 'household_facilities', iconColor: Colors.red),
      _MenuItemData(icon: Icons.pets, title: 'Household Assets, Livestock & CashFlow', route: 'household_assets', iconColor: Colors.purple),
      _MenuItemData(icon: Icons.checklist, title: 'Loan Utiliser Information', route: 'loan_utilizer_info', iconColor: Colors.teal),
      _MenuItemData(icon: Icons.person_add, title: 'Guarantor Information', route: 'guarantor_info', iconColor: Colors.blue),
      _MenuItemData(icon: Icons.attachment, title: 'Attachments', route: 'attachments', iconColor: Colors.orange),
      _MenuItemData(icon: Icons.file_present, title: 'Loan Submission Form', route: 'loan_submission', iconColor: Colors.green),
      _MenuItemData(icon: Icons.approval, title: 'Approval Submission', route: 'approval_submission', iconColor: Colors.blue),
    ];

    return Column(
      children: menuItems.map((item) {
        return _buildMenuItem(context, item, clientName, clientId);
      }).toList(),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItemData item, String clientName, String clientId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: item.iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(item.icon, color: item.iconColor, size: 24),
        ),
        title: Text(
          item.title,
          style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
        onTap: () => _navigateToForm(context, item.route, clientName, clientId),
      ),
    );
  }

  void _navigateToForm(BuildContext context, String route, String clientName, String clientId) {
    Widget page;

    switch (route) {
      case 'basic_client_info':
        page = BasicClientInfoPage(clientName: clientName, clientId: clientId);
        break;
      case 'group_formation':
        page = GroupFormationPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'loan_formation':
        page = LoanFormationPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'client_business_info':
        page = ClientBusinessInfoPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'domestic_income':
        page = DomesticIncomePage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'household_facilities':
        page = HouseholdFacilitiesPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'household_assets':
        page = HouseholdAssetsPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'loan_utilizer_info':
        page = LoanUtilizerInfoPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'guarantor_info':
        page = GuarantorInfoPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'attachments':
        page = AttachmentsPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'loan_submission':
        page = LoanSubmissionPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      case 'approval_submission':
        page = ApprovalSubmissionPage(clientName: clientName, clientId: clientId, cnic: cnic, memberId: memberId);
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: AppColors.primary,
                child: const Text(
                  'Client and Group Formation',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.white,
                child: Text(
                  'Already Saved Clients',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String route;
  final Color iconColor;

  _MenuItemData({required this.icon, required this.title, required this.route, required this.iconColor});
}
