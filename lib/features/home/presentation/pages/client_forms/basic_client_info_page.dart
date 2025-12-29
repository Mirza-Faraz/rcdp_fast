import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/input_formatters.dart';
import '../../../../../injection_container.dart';
import '../../../../auth/data/models/login_response_model.dart';
import '../../../../auth/data/models/user_data_helper.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import '../../../data/models/client_create_model.dart';
import '../../../data/models/client_dropdown_models.dart';
import '../../manager/client_info_cubit.dart';
import 'package:intl/intl.dart';

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
  String? _selectedVillage;

  String _officerName = '';
  String _officerDesignation = '';
  String _officerBranch = '';

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
    'Transgender',
  ];

  final List<String> _maritalStatuses = [
    'Select Marital Status',
    'Married',
    'Unmarried',
    'Widow',
    'Divorced',
    'Seperated',
  ];

  final List<String> _religions = [
    'Select Religion',
    'Islam',
    'Buddhism',
    'Christianity',
    'Sikhism',
    'Any other',
  ];

  @override
  void initState() {
    super.initState();
    _clientNameController.text = widget.clientName;
    _loadOfficerDetails();
  }

  Future<void> _loadOfficerDetails() async {
    final authRepo = sl<AuthRepository>();
    final profileResult = await authRepo.getSavedProfile();
    
    profileResult.fold(
      (failure) {
        // Fallback or leave as ...
      },
      (profile) {
        if (profile != null && mounted) {
          setState(() {
            _officerName = profile.userName;
            _officerDesignation = profile.designationDescription;
            _officerBranch = profile.branchNames;
          });
        }
      },
    );
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
    return BlocProvider(
      create: (context) => sl<ClientInfoCubit>()..loadDropdownData(43), // Defaulting to 43, will refine if branch id is dynamic
      child: BlocListener<ClientInfoCubit, ClientInfoState>(
        listener: (context, state) {
          if (state is ClientInfoSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is ClientInfoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: BlocBuilder<ClientInfoCubit, ClientInfoState>(
              builder: (context, state) {
                if (state is ClientInfoDropdownsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<EducationModel> educationData = [];
                List<VillageModel> villageData = [];
                List<RelationModel> relationData = [];

                if (state is ClientInfoDropdownsLoaded) {
                  educationData = state.educationLevels;
                  villageData = state.villages;
                  relationData = state.relations;
                }

                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                color: const Color(0xFF3359A1),
                                height: 120,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                                child: _buildClientHeader(),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                _buildClientInfoSection(educationData),
                                const SizedBox(height: 24),
                                _buildAddressSection(villageData),
                                const SizedBox(height: 24),
                                _buildNomineeSection(relationData),
                                const SizedBox(height: 24),
                                _buildGuardianSection(relationData),
                                const SizedBox(height: 24),
                                _buildLocationSection(),
                                const SizedBox(height: 32),
                                _buildSubmitButton(context),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state is ClientInfoSubmitting)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Removed _buildHeader as it's now integrated into the card

  Widget _buildClientHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home, color: Color(0xFF3359A1), size: 36),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 12),
              Text(
                '$_officerName | $_officerDesignation | $_officerBranch',
                style: const TextStyle(
                  color: Color(0xFF3359A1),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3359A1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.clientName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3359A1),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'CNIC',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3359A1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _maskCNIC(widget.clientId),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3359A1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Basic Client Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3359A1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _maskCNIC(String cnic) {
    var text = cnic.replaceAll('-', '');
    if (text.length < 13) return cnic;
    return '${text.substring(0, 5)}-${text.substring(5, 12)}-${text.substring(12)}';
  }

  Widget _buildClientInfoSection(List<EducationModel> educationData) {
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
        _buildReadOnlyField('CNIC', _maskCNIC(widget.clientId)),
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
        _buildTextField('Contact No.', _contactNoController, 
            hint: 'xxxx-xxxxxxx', 
            inputFormatters: [PhoneInputFormatter()],
            keyboardType: TextInputType.phone),
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
        _buildDropdown('Education', 
            ['Select Education', ...educationData.map((e) => e.educationDescription)], 
            _selectedEducation, (value) {
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

  Widget _buildAddressSection(List<VillageModel> villageData) {
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
        _buildDropdown('Village/Area', 
            ['Select Village', ...villageData.map((v) => v.description)], 
            _selectedVillage, (value) {
          setState(() {
            _selectedVillage = value == 'Select Village' ? null : value;
          });
        }),
      ],
    );
  }

  Widget _buildNomineeSection(List<RelationModel> relationData) {
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
          _buildDropdown('Nominee relation with Client', 
              ['Select Relation', ...relationData.map((r) => r.applicantRelationDescription)], 
              _selectedNomineeRelation, (value) {
            setState(() {
              _selectedNomineeRelation = value == 'Select Relation' ? null : value;
            });
          }),
          const SizedBox(height: 16),
          _buildTextField('Nominee Name', _nomineeNameController),
          const SizedBox(height: 16),
          _buildDateField('Nominee DOB', _nomineeDobController),
          const SizedBox(height: 16),
          _buildTextField('Nominee CNIC', _nomineeCnicController, 
              hint: 'xxxx-xxxxxxx-x', 
              inputFormatters: [CNICInputFormatter()],
              keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          _buildDateField('Nominee CNIC Expiry', _nomineeCnicExpiryController),
          const SizedBox(height: 16),
          _buildTextField('Nominee Contact No.', _nomineeContactController, 
              hint: 'xxxx-xxxxxxx', 
              inputFormatters: [PhoneInputFormatter()],
              keyboardType: TextInputType.phone),
        ],
      ],
    );
  }

  Widget _buildGuardianSection(List<RelationModel> relationData) {
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
        _buildDropdown('Guardian relation with Client', 
              ['Select Relation', ...relationData.map((r) => r.applicantRelationDescription)], 
              _selectedGuardianRelation, (value) {
          setState(() {
            _selectedGuardianRelation = value == 'Select Relation' ? null : value;
          });
        }),
        const SizedBox(height: 16),
        _buildDateField('Guardian DOB', _guardianDobController),
        const SizedBox(height: 16),
        _buildTextField('Guardian CNIC', _guardianCnicController, 
            hint: 'xxxx-xxxxxxx-x', 
            inputFormatters: [CNICInputFormatter()],
            keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildDateField('Guardian CNIC Expiry', _guardianCnicExpiryController),
        const SizedBox(height: 16),
        _buildTextField('Guardian Contact No.', _guardianContactController, 
            hint: 'xxxx-xxxxxxx', 
            inputFormatters: [PhoneInputFormatter()],
            keyboardType: TextInputType.phone),
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

  Widget _buildTextField(String label, TextEditingController controller, {
    String? hint, 
    bool obscureText = false, 
    bool hasDropdown = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
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
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
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
            color: Colors.white,
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
            color: Colors.white,
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

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleSubmit(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _handleSubmit(BuildContext context) async {
    // Basic validations
    if (_dobController.text.isEmpty || _cnicExpiryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select Date of Birth and CNIC Expiry')));
      return;
    }

    if (!_validateAge(_dobController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Age must be between 18 and 60 years')));
      return;
    }

    if (!_validateCNICExpiry(_cnicExpiryController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CNIC is expired or invalid expiry date')));
      return;
    }

    // Get dropdown IDs
    final state = context.read<ClientInfoCubit>().state;
    if (state is! ClientInfoDropdownsLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data is still loading, please wait.')));
      return;
    }

    final educationId = state.educationLevels.firstWhere(
      (e) => e.educationDescription == _selectedEducation,
      orElse: () => EducationModel(educationId: 0, educationDescription: ''),
    ).educationId;
    
    final villageId = int.tryParse(state.villages.firstWhere(
      (v) => v.description == _selectedVillage,
      orElse: () => VillageModel(id: '0', description: ''),
    ).id) ?? 0;
    
    final nomineeRelationId = state.relations.firstWhere(
      (r) => r.applicantRelationDescription == _selectedNomineeRelation,
      orElse: () => RelationModel(applicantRelationId: 0, applicantRelationDescription: ''),
    ).applicantRelationId;
    
    final guardianRelationId = state.relations.firstWhere(
      (r) => r.applicantRelationDescription == _selectedGuardianRelation,
      orElse: () => RelationModel(applicantRelationId: 0, applicantRelationDescription: ''),
    ).applicantRelationId;

    // Map Gender and Marital Status to IDs
    final genderId = _genders.indexOf(_selectedGender ?? '') ; // Male=1, Female=2, Transgender=3
    final maritalStatusId = _maritalStatuses.indexOf(_selectedMaritalStatus ?? ''); // Married=1, Unmarried=2, Widow=3, Divorced=4, Seperated=5

    final userId = await UserDataHelper.getUserId();
    // In a real scenario, branch ID would be fetched from saved user data. 
    // Defaulting to 43 as per the specific requirement example.
    const branchId = 43; 

    final request = ClientCreateRequest(
      nicNew: widget.clientId,
      cnicStatus: "Valid",
      nomineeCareOff: nomineeRelationId,
      userId: userId?.toString() ?? "91248",
      branchOfficeId: branchId,
      clientCareoffName: _parentNameController.text,
      piPhoneNo: _contactNoController.text,
      expiryNic: _cnicExpiryController.text,
      piDob: _dobController.text,
      piEducation: educationId,
      piExistingAddress: _existingAddressController.text,
      fatherName: _parentNameController.text,
      piGender: genderId,
      memberId: _memberIdController.text, // Assuming it's the ID
      latitude: "37.4219970703125", // Dummy for now
      longitude: "-122.08399963378906", // Dummy for now
      piMaritalStatus: maritalStatusId,
      piName: _clientNameController.text,
      nomineeCnic: _nomineeCnicController.text,
      nomineeExpiryNic: _nomineeCnicExpiryController.text,
      nomineeCareoffName: _nomineeNameController.text,
      nomineeDob: _nomineeDobController.text,
      nomineeName: _nomineeNameController.text,
      nomineePhoneNo: _nomineeContactController.text,
      piPermanentAddress: _permanentAddressController.text,
      piPresentAddress: _presentAddressController.text,
      religion: _selectedReligion ?? "",
      piVillage: villageId,
      extraField2: _guardianNameController.text, // Guardian name as per example
    );

    context.read<ClientInfoCubit>().submitClientInfo(request);
  }

  bool _validateAge(String dobText) {
    try {
      final date = DateFormat('dd/MMMM/yyyy').parse(dobText);
      final now = DateTime.now();
      var age = now.year - date.year;
      if (now.month < date.month || (now.month == date.month && now.day < date.day)) {
        age--;
      }
      return age >= 18 && age <= 60;
    } catch (e) {
      return false;
    }
  }

  bool _validateCNICExpiry(String expiryText) {
    try {
      final date = DateFormat('dd/MMMM/yyyy').parse(expiryText);
      return date.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // Format as "25/December/1999"
      controller.text = DateFormat('dd/MMMM/yyyy').format(picked);
    }
  }
}

