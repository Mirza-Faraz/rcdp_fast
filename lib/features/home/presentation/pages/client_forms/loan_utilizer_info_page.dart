import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../widgets/custom_dropdown.dart';
import 'guarantor_info_page.dart';

class LoanUtilizerInfoPage extends StatefulWidget {
  final String clientName;
  final String clientId;
  final String? cnic;
  final String? memberId;

  const LoanUtilizerInfoPage({super.key, required this.clientName, required this.clientId, this.cnic, this.memberId});

  @override
  State<LoanUtilizerInfoPage> createState() => _LoanUtilizerInfoPageState();
}

class _LoanUtilizerInfoPageState extends State<LoanUtilizerInfoPage> {
  // Dropdown values
  String? _selectedConsumerRelation;
  String? _selectedGender;
  String? _selectedEducation;

  // Text field controllers
  final TextEditingController _consumerNameController = TextEditingController();
  final TextEditingController _consumerCNICController = TextEditingController();
  final TextEditingController _consumerCNICExpiryController = TextEditingController();
  final TextEditingController _consumerParentageNameController = TextEditingController();
  final TextEditingController _businessOccupationController = TextEditingController();

  // Dropdown options
  final List<String> _consumerRelationOptions = ['Select Relation', 'BROTHER', 'BROTHER-IN-LAW', 'COUSION', 'Daughter', 'Father', 'FATHER-IN-LAW'];

  final List<String> _genderOptions = ['Select Gender', 'Male', 'Female', 'Transgender'];

  final List<String> _educationOptions = ['Select Education', 'Illiterate', 'Intermediate', 'Graduate', 'Post Graduate', 'Others'];

  @override
  void dispose() {
    _consumerNameController.dispose();
    _consumerCNICController.dispose();
    _consumerCNICExpiryController.dispose();
    _consumerParentageNameController.dispose();
    _businessOccupationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [_buildUserInfoCard(), const SizedBox(height: 24), _buildFormFields(), const SizedBox(height: 32), _buildNextButton(), const SizedBox(height: 16)],
                  ),
                ),
              ),
            ),
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Loan Utilizer Information',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Saima Test | Credit Officer | Multan 2',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                icon: Icon(Icons.home, color: AppColors.primary),
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Name', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      widget.clientName,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('CNIC', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      widget.cnic ?? widget.clientId,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('ID', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      widget.memberId ?? widget.clientId,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Loan Utilizer Information',
            style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomDropdown(
          label: 'Consumer relation with Client',
          hintText: 'Select Relation',
          selectedValue: _selectedConsumerRelation,
          items: _consumerRelationOptions,
          onChanged: (value) => setState(() => _selectedConsumerRelation = value),
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Consumer Name', controller: _consumerNameController),
        const SizedBox(height: 16),
        _buildTextField(label: 'Consumer CNIC', controller: _consumerCNICController),
        const SizedBox(height: 16),
        _buildTextField(label: 'Consumer CNIC Expiry', controller: _consumerCNICExpiryController, hintText: 'DD/MM/YYYY'),
        const SizedBox(height: 16),
        _buildTextField(label: 'Consumer Parentage Name', controller: _consumerParentageNameController),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Gender',
          hintText: 'Select Gender',
          selectedValue: _selectedGender,
          items: _genderOptions,
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Business/Occupation', controller: _businessOccupationController),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Education',
          hintText: 'Select Education',
          selectedValue: _selectedEducation,
          items: _educationOptions,
          onChanged: (value) => setState(() => _selectedEducation = value),
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GuarantorInfoPage(clientName: widget.clientName, clientId: widget.clientId, cnic: widget.cnic, memberId: widget.memberId),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
