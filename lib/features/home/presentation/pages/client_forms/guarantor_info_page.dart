import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../widgets/custom_dropdown.dart';
import 'attachments_page.dart';

class GuarantorInfoPage extends StatefulWidget {
  final String clientName;
  final String clientId;
  final String? cnic;
  final String? memberId;

  const GuarantorInfoPage({super.key, required this.clientName, required this.clientId, this.cnic, this.memberId});

  @override
  State<GuarantorInfoPage> createState() => _GuarantorInfoPageState();
}

class _GuarantorInfoPageState extends State<GuarantorInfoPage> {
  final List<Map<String, dynamic>> _guarantors = [];

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
                child: Column(
                  children: [
                    _buildUserInfoCard(),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _guarantors.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(padding: const EdgeInsets.all(16.0), itemCount: _guarantors.length, itemBuilder: (context, index) => _buildGuarantorCard(index)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _addGuarantor(),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: Text('Add Guarantor ${_guarantors.length + 1}', style: const TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 12)),
                            ),
                          ),
                          if (_guarantors.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AttachmentsPage(clientName: widget.clientName, clientId: widget.clientId, cnic: widget.cnic, memberId: widget.memberId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
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
              'Guarantor Information',
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
            'Guarantor Information',
            style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Guarantors Added',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text('Tap "Add Guarantor" to add a new guarantor', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuarantorCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          'Guarantor No. ${index + 1}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: () => _navigateToGuarantorDetail(index),
      ),
    );
  }

  void _addGuarantor() {
    final newGuarantor = <String, dynamic>{
      'name': '',
      'fatherName': '',
      'cnic': '',
      'phoneNumber': '',
      'dob': '',
      'cnicExpiry': '',
      'relation': null,
      'address': '',
      'yearsKnown': '',
      'occupation': '',
      'location': '',
      'fingerprintCaptured': false,
    };
    setState(() {
      _guarantors.add(newGuarantor);
    });
    _navigateToGuarantorDetail(_guarantors.length - 1);
  }

  void _navigateToGuarantorDetail(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuarantorDetailPage(
          guarantorIndex: index,
          guarantor: _guarantors[index],
          onSave: (updatedGuarantor) {
            setState(() {
              _guarantors[index] = updatedGuarantor;
            });
          },
          clientName: widget.clientName,
          clientId: widget.clientId,
          cnic: widget.cnic,
          memberId: widget.memberId,
        ),
      ),
    );
  }
}

class GuarantorDetailPage extends StatefulWidget {
  final int guarantorIndex;
  final Map<String, dynamic> guarantor;
  final Function(Map<String, dynamic>) onSave;
  final String clientName;
  final String clientId;
  final String? cnic;
  final String? memberId;

  const GuarantorDetailPage({
    super.key,
    required this.guarantorIndex,
    required this.guarantor,
    required this.onSave,
    required this.clientName,
    required this.clientId,
    this.cnic,
    this.memberId,
  });

  @override
  State<GuarantorDetailPage> createState() => _GuarantorDetailPageState();
}

class _GuarantorDetailPageState extends State<GuarantorDetailPage> {
  String? _selectedRelation;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cnicExpiryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _yearsKnownController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  bool _fingerprintCaptured = false;

  final List<String> _relationOptions = [
    'Select Relation',
    'BROTHER',
    'BROTHER-IN-LAW',
    'COUSION',
    'Daughter',
    'Father',
    'FRIEND',
    'Husband',
    'NEIGHBOUR',
    'Nephew',
    'FATHER-IN-LAW',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.guarantor['name'] ?? '';
    _fatherNameController.text = widget.guarantor['fatherName'] ?? '';
    _cnicController.text = widget.guarantor['cnic'] ?? '';
    _phoneNumberController.text = widget.guarantor['phoneNumber'] ?? '';
    _dobController.text = widget.guarantor['dob'] ?? '';
    _cnicExpiryController.text = widget.guarantor['cnicExpiry'] ?? '';
    _addressController.text = widget.guarantor['address'] ?? '';
    _yearsKnownController.text = widget.guarantor['yearsKnown'] ?? '';
    _occupationController.text = widget.guarantor['occupation'] ?? '';
    _latitudeController.text = widget.guarantor['latitude'] ?? '';
    _longitudeController.text = widget.guarantor['longitude'] ?? '';
    _selectedRelation = widget.guarantor['relation'];
    _fingerprintCaptured = widget.guarantor['fingerprintCaptured'] ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _cnicController.dispose();
    _phoneNumberController.dispose();
    _dobController.dispose();
    _cnicExpiryController.dispose();
    _addressController.dispose();
    _yearsKnownController.dispose();
    _occupationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
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
                    children: [
                      _buildUserInfoCard(),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Text(
                              'Guarantor No. ${widget.guarantorIndex + 1}',
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormFields(),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                      const SizedBox(height: 16),
                    ],
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
              'Guarantor Information',
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
            'Guarantor Information',
            style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(label: 'Guarantor Name', controller: _nameController),
        const SizedBox(height: 16),
        _buildTextField(label: 'Guarantor Father Name', controller: _fatherNameController),
        const SizedBox(height: 16),
        _buildTextField(label: 'Guarantor CNIC', controller: _cnicController),
        const SizedBox(height: 16),
        _buildTextField(label: 'Guarantor Phone Number', controller: _phoneNumberController, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField(label: 'Guarantor DOB', controller: _dobController, hintText: 'DD/MM/YYYY'),
        const SizedBox(height: 16),
        _buildTextField(label: 'Guarantor CNIC Expiry', controller: _cnicExpiryController, hintText: 'DD/MM/YYYY'),
        const SizedBox(height: 16),
        CustomDropdown(
          label: 'Guarantor relation with Client',
          hintText: 'Select Relation',
          selectedValue: _selectedRelation,
          items: _relationOptions,
          onChanged: (value) => setState(() => _selectedRelation = value),
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Guarantor Address', controller: _addressController, maxLines: 3),
        const SizedBox(height: 16),
        _buildTextField(label: 'Years Known', controller: _yearsKnownController, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(label: 'Guarantor Occupation', controller: _occupationController),
        const SizedBox(height: 24),
        _buildLocationSection(),
        const SizedBox(height: 24),
        _buildFingerprintSection(),
      ],
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType? keyboardType, String? hintText, int maxLines = 1}) {
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
            maxLines: maxLines,
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

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Simulate location capture
                  setState(() {
                    _latitudeController.text = '31.4504';
                    _longitudeController.text = '73.1350';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location captured'), backgroundColor: AppColors.primary));
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text('Capture Location'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to map or location picker
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigate to location'), backgroundColor: AppColors.primary));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Navigate'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(label: 'Latitude', controller: _latitudeController, keyboardType: TextInputType.number),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(label: 'Longitude', controller: _longitudeController, keyboardType: TextInputType.number),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFingerprintSection() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _fingerprintCaptured = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fingerprint captured'), backgroundColor: AppColors.primary));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
            child: const Text('Capture Fingerprint'),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          _fingerprintCaptured ? 'Captured' : 'Not Captured',
          style: TextStyle(fontSize: 14, color: _fingerprintCaptured ? Colors.green : AppColors.primary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onSave({
            'name': _nameController.text,
            'fatherName': _fatherNameController.text,
            'cnic': _cnicController.text,
            'phoneNumber': _phoneNumberController.text,
            'dob': _dobController.text,
            'cnicExpiry': _cnicExpiryController.text,
            'relation': _selectedRelation,
            'address': _addressController.text,
            'yearsKnown': _yearsKnownController.text,
            'occupation': _occupationController.text,
            'latitude': _latitudeController.text,
            'longitude': _longitudeController.text,
            'fingerprintCaptured': _fingerprintCaptured,
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guarantor information saved'), backgroundColor: AppColors.primary));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
