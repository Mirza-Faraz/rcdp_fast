import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../widgets/custom_dropdown.dart';
import 'approval_submission_page.dart';

class LoanSubmissionPage extends StatefulWidget {
  final String clientName;
  final String clientId;
  final String? cnic;
  final String? memberId;

  const LoanSubmissionPage({super.key, required this.clientName, required this.clientId, this.cnic, this.memberId});

  @override
  State<LoanSubmissionPage> createState() => _LoanSubmissionPageState();
}

class _LoanSubmissionPageState extends State<LoanSubmissionPage> {
  // Dropdown values
  String? _selectedProduct;
  String? _selectedSubProduct;
  String? _selectedPhasePartner;

  // Text field controllers
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();

  // Dropdown options
  final List<String> _productOptions = [
    'Select Product',
    'ACAG',
    'CED',
    'EDF',
    'LSF',
    'BEL',
    'PMIFL Monthly',
    'PMIFL 6 Month',
    'Pak Oman',
    'IFL2 Monthly',
    'IFL2 6 Monthly',
    'PMIFL2 8 Monthly',
  ];

  final List<String> _subProductOptions = ['Select Sub Product', 'CED'];

  final List<String> _phasePartnerOptions = ['Select Phase', 'PMIC ADB', 'NBP', 'BOP', 'Atta Chaki'];

  @override
  void initState() {
    super.initState();
    _memberIdController.text = widget.memberId ?? widget.clientId;
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _loanAmountController.dispose();
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
                    children: [_buildUserInfoCard(), const SizedBox(height: 24), _buildFormFields(), const SizedBox(height: 32), _buildActionButtons(), const SizedBox(height: 16)],
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
              'Loan Submission Form',
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
            'Loan Submission Form',
            style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GROUP ID 0',
          style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Member Id', style: TextStyle(fontSize: 14, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: _memberIdController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomDropdown(
                label: 'Product',
                hintText: 'Select Product',
                selectedValue: _selectedProduct,
                items: _productOptions,
                onChanged: (value) => setState(() => _selectedProduct = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Sub Product',
          hintText: 'Select Sub Product',
          selectedValue: _selectedSubProduct,
          items: _subProductOptions,
          onChanged: (value) => setState(() => _selectedSubProduct = value),
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Phase/Partner',
          hintText: 'Select Phase',
          selectedValue: _selectedPhasePartner,
          items: _phasePartnerOptions,
          onChanged: (value) => setState(() => _selectedPhasePartner = value),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Loan Amount',
          controller: _loanAmountController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, ThousandsSeparatorInputFormatter()],
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters}) {
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
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Loan information updated'), backgroundColor: AppColors.primary));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Update', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApprovalSubmissionPage(clientName: widget.clientName, clientId: widget.clientId, cnic: widget.cnic, memberId: widget.memberId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && (digitsOnly.length - i) % 3 == 0) formatted += ',';
      formatted += digitsOnly[i];
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
