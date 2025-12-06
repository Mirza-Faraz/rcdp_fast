import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../widgets/custom_dropdown.dart';
import 'domestic_income_page.dart';

class ClientBusinessInfoPage extends StatefulWidget {
  final String clientName;
  final String clientId;
  final String? cnic;
  final String? memberId;

  const ClientBusinessInfoPage({super.key, required this.clientName, required this.clientId, this.cnic, this.memberId});

  @override
  State<ClientBusinessInfoPage> createState() => _ClientBusinessInfoPageState();
}

class _ClientBusinessInfoPageState extends State<ClientBusinessInfoPage> {
  // Dropdown values
  String? _selectedNatureOfBusiness;
  String? _selectedBusinessLocation;
  String? _selectedMaintainLedger;

  // Text field controllers
  final TextEditingController _presentOccupationController = TextEditingController();
  final TextEditingController _businessAddressController = TextEditingController();
  final TextEditingController _totalBusinessExperienceController = TextEditingController();
  final TextEditingController _totalBusinessInvestmentController = TextEditingController();
  final TextEditingController _totalEmployeesController = TextEditingController();
  final TextEditingController _electricityConsumerNoController = TextEditingController();

  // Dropdown options
  final List<String> _natureOfBusinessOptions = ['Select Business Nature', 'Personal', 'Partnership'];
  final List<String> _businessLocationOptions = ['Select Business Location', 'Market', 'Outside Market', 'Residential Area', 'Non-residential', 'Nearby villages'];
  final List<String> _maintainLedgerOptions = ['Select Option', 'Yes', 'No'];

  @override
  void dispose() {
    _presentOccupationController.dispose();
    _businessAddressController.dispose();
    _totalBusinessExperienceController.dispose();
    _totalBusinessInvestmentController.dispose();
    _totalEmployeesController.dispose();
    _electricityConsumerNoController.dispose();
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
              'Client Business Information',
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
            'Client Business Information',
            style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(label: 'Present Occupation', controller: _presentOccupationController),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Nature Of Business',
          hintText: 'Select Business Nature',
          selectedValue: _selectedNatureOfBusiness,
          items: _natureOfBusinessOptions,
          onChanged: (value) => setState(() => _selectedNatureOfBusiness = value),
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Business Location',
          hintText: 'Select Business Location',
          selectedValue: _selectedBusinessLocation,
          items: _businessLocationOptions,
          onChanged: (value) => setState(() => _selectedBusinessLocation = value),
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Business Address', controller: _businessAddressController),
        const SizedBox(height: 16),
        _buildTextField(label: 'Total Business Experience. (in years)', controller: _totalBusinessExperienceController, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Maintain Ledger?',
          hintText: 'Select Option',
          selectedValue: _selectedMaintainLedger,
          items: _maintainLedgerOptions,
          onChanged: (value) => setState(() => _selectedMaintainLedger = value),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Total Business Investment',
          controller: _totalBusinessInvestmentController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, ThousandsSeparatorInputFormatter()],
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Total Employees', controller: _totalEmployeesController, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(label: 'Electricity Consumer No.', controller: _electricityConsumerNoController),
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

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DomesticIncomePage(clientName: widget.clientName, clientId: widget.clientId, cnic: widget.cnic, memberId: widget.memberId),
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
