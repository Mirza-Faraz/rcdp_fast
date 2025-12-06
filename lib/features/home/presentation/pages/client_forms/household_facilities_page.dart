import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../widgets/custom_dropdown.dart';
import 'household_assets_page.dart';

class HouseholdFacilitiesPage extends StatefulWidget {
  final String clientName;
  final String clientId;
  final String? cnic;
  final String? memberId;

  const HouseholdFacilitiesPage({super.key, required this.clientName, required this.clientId, this.cnic, this.memberId});

  @override
  State<HouseholdFacilitiesPage> createState() => _HouseholdFacilitiesPageState();
}

class _HouseholdFacilitiesPageState extends State<HouseholdFacilitiesPage> {
  // Dropdown values
  String? _selectedHouseOwnership;
  String? _selectedHouseConstruction;

  // Text field controllers
  final TextEditingController _sizeOfHouseController = TextEditingController();

  // Checkbox states for Household Facilities
  bool _electricity = false;
  bool _gas = false;
  bool _motorPump = false;
  bool _telephone = false;
  bool _tv = false;
  bool _refrigerator = false;
  bool _washingMachine = false;
  bool _toilet = false;
  bool _drinkingWater = false;
  bool _cycle = false;
  bool _computer = false;
  bool _juicer = false;
  bool _fan = false;

  // Radio button for Client Health
  String? _selectedHealthStatus;

  // Checkbox states for Health Conditions
  bool _hepatitis = false;
  bool _sugar = false;
  bool _heart = false;
  bool _tb = false;
  bool _hbp = false;
  bool _other = false;

  // Dropdown options
  final List<String> _houseOwnershipOptions = ['Select Ownership', 'Owned', 'Rented', 'Others'];
  final List<String> _houseConstructionOptions = ['Select Construction', 'Cemented', 'Very Poor', 'Poor', 'Semi Cemented'];

  @override
  void dispose() {
    _sizeOfHouseController.dispose();
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
              'Household & Health',
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
            'Household & Health',
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
        CustomDropdown(
          label: 'House Ownership',
          hintText: 'Select Ownership',
          selectedValue: _selectedHouseOwnership,
          items: _houseOwnershipOptions,
          onChanged: (value) => setState(() => _selectedHouseOwnership = value),
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'House Construction',
          hintText: 'Select Construction',
          selectedValue: _selectedHouseConstruction,
          items: _houseConstructionOptions,
          onChanged: (value) => setState(() => _selectedHouseConstruction = value),
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Size of House (Marlas)', controller: _sizeOfHouseController, keyboardType: TextInputType.number),
        const SizedBox(height: 24),
        const Text(
          'Household Facilities',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildHouseholdFacilitiesCheckboxes(),
        const SizedBox(height: 24),
        const Text(
          'Client Health',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildHealthStatusRadioButtons(),
        const SizedBox(height: 16),
        _buildHealthConditionsCheckboxes(),
      ],
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType? keyboardType}) {
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
            inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : null,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
          ),
        ),
      ],
    );
  }

  Widget _buildHouseholdFacilitiesCheckboxes() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckbox('Electricity', _electricity, (value) => setState(() => _electricity = value!)),
              _buildCheckbox('Gas', _gas, (value) => setState(() => _gas = value!)),
              _buildCheckbox('Motor Pump', _motorPump, (value) => setState(() => _motorPump = value!)),
              _buildCheckbox('Telephone', _telephone, (value) => setState(() => _telephone = value!)),
              _buildCheckbox('TV', _tv, (value) => setState(() => _tv = value!)),
              _buildCheckbox('Refrigerator', _refrigerator, (value) => setState(() => _refrigerator = value!)),
              _buildCheckbox('Washing Machine', _washingMachine, (value) => setState(() => _washingMachine = value!)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckbox('Cycle', _cycle, (value) => setState(() => _cycle = value!)),
              _buildCheckbox('Computer', _computer, (value) => setState(() => _computer = value!)),
              _buildCheckbox('Juicer', _juicer, (value) => setState(() => _juicer = value!)),
              _buildCheckbox('Fan', _fan, (value) => setState(() => _fan = value!)),
              _buildCheckbox('Toilet', _toilet, (value) => setState(() => _toilet = value!)),
              _buildCheckbox('Drinking Water', _drinkingWater, (value) => setState(() => _drinkingWater = value!)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildHealthStatusRadioButtons() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Excellent', style: TextStyle(fontSize: 14, color: Colors.black87)),
          value: 'Excellent',
          groupValue: _selectedHealthStatus,
          onChanged: (value) => setState(() => _selectedHealthStatus = value),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Good', style: TextStyle(fontSize: 14, color: Colors.black87)),
          value: 'Good',
          groupValue: _selectedHealthStatus,
          onChanged: (value) => setState(() => _selectedHealthStatus = value),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Normal', style: TextStyle(fontSize: 14, color: Colors.black87)),
          value: 'Normal',
          groupValue: _selectedHealthStatus,
          onChanged: (value) => setState(() => _selectedHealthStatus = value),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Poor', style: TextStyle(fontSize: 14, color: Colors.black87)),
          value: 'Poor',
          groupValue: _selectedHealthStatus,
          onChanged: (value) => setState(() => _selectedHealthStatus = value),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Very Poor', style: TextStyle(fontSize: 14, color: Colors.black87)),
          value: 'Very Poor',
          groupValue: _selectedHealthStatus,
          onChanged: (value) => setState(() => _selectedHealthStatus = value),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
      ],
    );
  }

  Widget _buildHealthConditionsCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckbox('Hepatitis', _hepatitis, (value) => setState(() => _hepatitis = value!)),
        _buildCheckbox('Sugar', _sugar, (value) => setState(() => _sugar = value!)),
        _buildCheckbox('Heart', _heart, (value) => setState(() => _heart = value!)),
        _buildCheckbox('TB', _tb, (value) => setState(() => _tb = value!)),
        _buildCheckbox('HBP', _hbp, (value) => setState(() => _hbp = value!)),
        _buildCheckbox('Other', _other, (value) => setState(() => _other = value!)),
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
              builder: (context) => HouseholdAssetsPage(clientName: widget.clientName, clientId: widget.clientId, cnic: widget.cnic, memberId: widget.memberId),
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
