import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class BasicClientInfoPage extends StatefulWidget {
  final String clientName;
  final String clientId;

  const BasicClientInfoPage({
    super.key,
    required this.clientName,
    required this.clientId,
  });

  @override
  State<BasicClientInfoPage> createState() => _BasicClientInfoPageState();
}

class _BasicClientInfoPageState extends State<BasicClientInfoPage> {
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cnicExpiryController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _existingAddressController = TextEditingController();
  final TextEditingController _presentAddressController = TextEditingController();
  final TextEditingController _permanentAddressController = TextEditingController();
  final TextEditingController _villageAreaController = TextEditingController();

  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedEducation;
  String? _selectedReligion;

  bool _nomineeEnabled = true;
  String? _selectedNomineeRelation;
  final TextEditingController _nomineeNameController = TextEditingController();
  final TextEditingController _nomineeDobController = TextEditingController();
  final TextEditingController _nomineeCnicController = TextEditingController();
  final TextEditingController _nomineeCnicExpiryController = TextEditingController();
  final TextEditingController _nomineeContactController = TextEditingController();

  String? _selectedGuardianRelation;
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianDobController = TextEditingController();
  final TextEditingController _guardianCnicController = TextEditingController();
  final TextEditingController _guardianCnicExpiryController = TextEditingController();
  final TextEditingController _guardianContactController = TextEditingController();

  final List<String> _genders = [
    'Select Gender',
    'Male',
    'Female',
    'Other',
  ];

  final List<String> _maritalStatuses = [
    'Select Marital Status',
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];

  final List<String> _educationLevels = [
    'Select Education',
    'No Education',
    'Primary',
    'Middle',
    'Matric',
    'Intermediate',
    'Bachelor',
    'Master',
    'PhD',
  ];

  final List<String> _religions = [
    'Select Religion',
    'Islam',
    'Christianity',
    'Hinduism',
    'Sikhism',
    'Buddhism',
    'Other',
  ];

  final List<String> _relations = [
    'Select Relation',
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Son',
    'Daughter',
    'Husband',
    'Wife',
    'Uncle',
    'Aunt',
    'Cousin',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _clientNameController.text = widget.clientName;
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _clientNameController.dispose();
    _parentNameController.dispose();
    _dobController.dispose();
    _cnicExpiryController.dispose();
    _contactNoController.dispose();
    _existingAddressController.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    _villageAreaController.dispose();
    _nomineeNameController.dispose();
    _nomineeDobController.dispose();
    _nomineeCnicController.dispose();
    _nomineeCnicExpiryController.dispose();
    _nomineeContactController.dispose();
    _guardianNameController.dispose();
    _guardianDobController.dispose();
    _guardianCnicController.dispose();
    _guardianCnicExpiryController.dispose();
    _guardianContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClientHeader(),
                    const SizedBox(height: 24),
                    _buildClientInfoSection(),
                    const SizedBox(height: 24),
                    _buildAddressSection(),
                    const SizedBox(height: 24),
                    _buildNomineeSection(),
                    const SizedBox(height: 24),
                    _buildGuardianSection(),
                    const SizedBox(height: 24),
                    _buildLocationSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Client Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildClientHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Khalid Test | Credit Officer | Lahore 2',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ahmad',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CNIC',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.clientId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Basic Client Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Client Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        _buildReadOnlyField('CNIC', widget.clientId),
        const SizedBox(height: 16),
        _buildTextField('Member ID', _memberIdController, hint: '.........', obscureText: true),
        const SizedBox(height: 16),
        _buildTextField('Client Name', _clientNameController),
        const SizedBox(height: 16),
        _buildTextField('Parent Name as per CNIC', _parentNameController),
        const SizedBox(height: 16),
        _buildDateField('DOB (Date of Birth)', _dobController),
        const SizedBox(height: 16),
        _buildDateField('CNIC Expiry', _cnicExpiryController),
        const SizedBox(height: 16),
        _buildTextField('Contact No.', _contactNoController, hint: '####-#######'),
        const SizedBox(height: 16),
        _buildDropdown('Gender', _genders, _selectedGender, (value) {
          setState(() {
            _selectedGender = value == 'Select Gender' ? null : value;
          });
        }),
        const SizedBox(height: 16),
        _buildDropdown('Marital Status', _maritalStatuses, _selectedMaritalStatus, (value) {
          setState(() {
            _selectedMaritalStatus = value == 'Select Marital Status' ? null : value;
          });
        }),
        const SizedBox(height: 16),
        _buildDropdown('Education', _educationLevels, _selectedEducation, (value) {
          setState(() {
            _selectedEducation = value == 'Select Education' ? null : value;
          });
        }),
        const SizedBox(height: 16),
        _buildDropdown('Religion', _religions, _selectedReligion, (value) {
          setState(() {
            _selectedReligion = value == 'Select Religion' ? null : value;
          });
        }),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Client Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField('Existing Address', _existingAddressController),
        const SizedBox(height: 16),
        _buildTextField('Present Address', _presentAddressController),
        const SizedBox(height: 16),
        _buildTextField('Permanent Address', _permanentAddressController),
        const SizedBox(height: 16),
        _buildTextField('Village/Area', _villageAreaController, hasDropdown: true),
      ],
    );
  }

  Widget _buildNomineeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nominee Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Switch(
              value: _nomineeEnabled,
              onChanged: (value) {
                setState(() {
                  _nomineeEnabled = value;
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
        if (_nomineeEnabled) ...[
          const SizedBox(height: 16),
          _buildDropdown('Nominee relation with Client', _relations, _selectedNomineeRelation, (value) {
            setState(() {
              _selectedNomineeRelation = value == 'Select Relation' ? null : value;
            });
          }),
          const SizedBox(height: 16),
          _buildTextField('Nominee Name', _nomineeNameController),
          const SizedBox(height: 16),
          _buildDateField('Nominee DOB', _nomineeDobController),
          const SizedBox(height: 16),
          _buildTextField('Nominee CNIC', _nomineeCnicController),
          const SizedBox(height: 16),
          _buildDateField('Nominee CNIC Expiry', _nomineeCnicExpiryController),
          const SizedBox(height: 16),
          _buildTextField('Nominee Contact No.', _nomineeContactController, hint: '####-#######'),
        ],
      ],
    );
  }

  Widget _buildGuardianSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guardian Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField('Guardian Name', _guardianNameController),
        const SizedBox(height: 16),
        _buildDropdown('Guardian relation with Client', _relations, _selectedGuardianRelation, (value) {
          setState(() {
            _selectedGuardianRelation = value == 'Select Relation' ? null : value;
          });
        }),
        const SizedBox(height: 16),
        _buildDateField('Guardian DOB', _guardianDobController),
        const SizedBox(height: 16),
        _buildTextField('Guardian CNIC', _guardianCnicController),
        const SizedBox(height: 16),
        _buildDateField('Guardian CNIC Expiry', _guardianCnicExpiryController),
        const SizedBox(height: 16),
        _buildTextField('Guardian Contact No.', _guardianContactController, hint: '####-#######'),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Capture Location'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Navigate'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Latitude'),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('-'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Longitude'),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('-'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Capture Fingerprint'),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Not Captured',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, bool obscureText = false, bool hasDropdown = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: hasDropdown
                  ? const Icon(Icons.arrow_drop_down, color: Colors.grey)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Select date',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            readOnly: true,
            onTap: () => _selectDate(context, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue ?? items[0],
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: item == items[0] ? Colors.grey : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }
}

