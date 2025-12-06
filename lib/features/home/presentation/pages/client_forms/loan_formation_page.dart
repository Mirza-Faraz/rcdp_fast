import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../widgets/custom_dropdown.dart';

class LoanFormationPage extends StatefulWidget {
  final String clientName;
  final String clientId;
  final String? cnic;
  final String? memberId;

  const LoanFormationPage({
    super.key,
    required this.clientName,
    required this.clientId,
    this.cnic,
    this.memberId,
  });

  @override
  State<LoanFormationPage> createState() => _LoanFormationPageState();
}

class _LoanFormationPageState extends State<LoanFormationPage> {
  // Dropdown values
  String? _selectedProduct;
  String? _selectedSubProduct;
  String? _selectedPhasePartner;
  String? _selectedSector;
  String? _selectedLoanUtilization;
  String? _selectedCustomerProduct;
  String? _selectedPEP;
  String? _selectedDeliveryChannel;

  // Text field controllers
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _loanDemandController = TextEditingController();

  // Dropdown options
  final List<String> _productOptions = [
    'Select Product',
    'ACAG',
    'EDF',
    'LSF',
    'BEL',
    'PMIFL Monthly',
    'PMIFL 6 Month',
    'Pak Oman',
    'IFL2 Monthly',
    'IFL2 6 Monthly',
    'PMIFL2 8 Monthly',
    'CED',
  ];

  final List<String> _subProductOptions = [
    'Select Sub Product',
    'CED',
  ];

  final List<String> _phasePartnerOptions = [
    'Select Phase/Partner',
    'NBP',
    'Atta Chaki',
  ];

  final List<String> _sectorOptions = [
    'Select Sector',
    'Handi Craft',
    'Trading Business',
    'Agriculture',
    'Manufacturing',
    'Others',
    'Live Stock',
  ];

  final List<String> _loanUtilizationOptions = [
    'Select Utilization',
    'LiveStock',
    'Goat',
    'Sheep',
    'Cow',
    'Buffalo',
    'Live Stock',
  ];

  final List<String> _customerProductOptions = [
    'Select Customer and Product',
    'Customer with Simple, obvious, easy understandable Cashflow and income source',
    'Customer involved in a business that Handles large amount of cash',
    'Business with a complicated Ownership Structure',
    'Customer who makes regular transactions with Same Individual or Group of Individual',
    'Customer household member\'s social and religious contacts',
    'Customers are not wanting to provide documentation or providing documents that isn\'t satisfactory',
    'Not wanting to reveal the name of a person they represent',
    'Agreeing to bear very high or non commercial penalties or changes',
    'Entering into transactions that don\'t make any commercial sense',
    'Customer who makes reqular transactions with Same Individual or Group of Individual',
  ];

  final List<String> _pepOptions = [
    'Select PEP',
    'Grade 17 to Grade 21 (Ex or Current, Their Family member and their close associates)',
    'Members of the Federal Government',
    'Federal Cabinet Members (Ex or Current, Their Family member and their close associates)',
    'Ministers, Advisors (Ex or Current, Their Family member and their close associates)',
    'DPO, AC, DC (Ex or Current, Their Family member and their close associates)',
    'Prominent Social or Political Worker (Ex or Current, Their Family member and their close associates)',
    'Customer has any type of Relationships with any higher garde government official (Ex or Current)',
    'UC Chairman, Vice Chairman, General Councilor, (Ex or Current / His her Family Members Or Close Associates)',
    'Head of State, Province, or Government (Ex or Current, Their Family member and their close associates)',
    'MNA, MPA, (Ex or Current, Their Family member and their close associates)',
    'High Ranked Judicial Officials i.e Judges & Lawyers (Ex or Current, Their Family member and their close associates)',
    'High Ranked Army Officials (Major or Above Major Ranked) (Ex or Current, Their Family member and their close associates)',
    'Senior Executive of state-owned Corporations (Ex or Current, Their Family member and their close associates)',
    'Customer Family member\'s have any types of relationship with any Political Exposed Person (Ex or Current)',
    'Customer of his/her family have any type of linkages with the Parliamentarians (Active, Ex or Current), Law enforcement higher grade Officials (Ex or Current)',
    'Grade 22 Govt. Officials i.e Secretary to the Govt. of Pakistan, Chief Secretary to a Provincial Government, Director General/ Chairman of a large state-owned Corporation or agency such as Federal Board of Revenue, Federal Investigation Agency, Intelligence bureau etc, Inspector General of Police (Ex or Current, Their Family member and their close associates)',
    'Any member of Political Party i.e. President/Chairman, Vice President/Vice Chairman, Coordinator, Secretary etc. at UC and all above levels',
    'High Ranked Judicial Officials i.e Jugdes & Lawyers (Ex or Current, Their Family member and their close associates)',
    'Non-Political Persons',
    'High Ranked Judicial Officials i.e Ju',
  ];

  final List<String> _deliveryChannelOptions = [
    'Select Delivery Channel',
    'COC',
  ];

  @override
  void initState() {
    super.initState();
    _memberIdController.text = widget.memberId ?? widget.clientId;
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _loanDemandController.dispose();
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfoCard(),
                      const SizedBox(height: 24),
                      _buildFormFields(),
                      const SizedBox(height: 32),
                      _buildNextButton(),
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
              'Loan Formation',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.home, color: AppColors.primary),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
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
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.clientName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'CNIC',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.cnic ?? widget.clientId,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'ID',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.memberId ?? widget.clientId,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Loan Formation',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Product dropdown
        CustomDropdown(
          label: 'Product',
          hintText: 'Select Product',
          selectedValue: _selectedProduct,
          items: _productOptions,
          searchable: true,
          onChanged: (value) {
            setState(() {
              _selectedProduct = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Sub Product dropdown
        CustomDropdown(
          label: 'Sub Product',
          hintText: 'Select Sub Product',
          selectedValue: _selectedSubProduct,
          items: _subProductOptions,
          onChanged: (value) {
            setState(() {
              _selectedSubProduct = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Phase/Partner dropdown
        CustomDropdown(
          label: 'Phase/Partner',
          hintText: 'Select Phase/Partner',
          selectedValue: _selectedPhasePartner,
          items: _phasePartnerOptions,
          onChanged: (value) {
            setState(() {
              _selectedPhasePartner = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Member ID text field
        _buildTextField(
          label: 'Member ID',
          controller: _memberIdController,
          readOnly: true,
        ),
        const SizedBox(height: 16),

        // Loan Demand text field
        _buildTextField(
          label: 'Loan Demand',
          controller: _loanDemandController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsSeparatorInputFormatter(),
          ],
        ),
        const SizedBox(height: 16),

        // Sector dropdown
        CustomDropdown(
          label: 'Sector',
          hintText: 'Select Sector',
          selectedValue: _selectedSector,
          items: _sectorOptions,
          onChanged: (value) {
            setState(() {
              _selectedSector = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Loan Utilization Detail dropdown
        CustomDropdown(
          label: 'Loan Utilization Detail',
          hintText: 'Select Utilization',
          selectedValue: _selectedLoanUtilization,
          items: _loanUtilizationOptions,
          onChanged: (value) {
            setState(() {
              _selectedLoanUtilization = value;
            });
          },
        ),
        const SizedBox(height: 24),

        // Divider
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
        const SizedBox(height: 16),

        // Risk Based Assessment section
        Text(
          'Risk Based Assessment (RBA)',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Customer and Product dropdown
        CustomDropdown(
          label: 'Customer and Product',
          hintText: 'Select Customer and Product',
          selectedValue: _selectedCustomerProduct,
          items: _customerProductOptions,
          searchable: true,
          onChanged: (value) {
            setState(() {
              _selectedCustomerProduct = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // PEP dropdown
        CustomDropdown(
          label: 'PEP',
          hintText: 'Select PEP',
          selectedValue: _selectedPEP,
          items: _pepOptions,
          searchable: true,
          onChanged: (value) {
            setState(() {
              _selectedPEP = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Delivery Channel dropdown
        CustomDropdown(
          label: 'Delivery Channel',
          hintText: 'Select Delivery Channel',
          selectedValue: _selectedDeliveryChannel,
          items: _deliveryChannelOptions,
          onChanged: (value) {
            setState(() {
              _selectedDeliveryChannel = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            style: TextStyle(
              fontSize: 14,
              color: readOnly ? AppColors.primary : Colors.black87,
            ),
            decoration: const InputDecoration(
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
          // You can add validation here if needed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loan Formation information saved'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Input formatter for thousands separator
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Add commas for thousands separator
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && (digitsOnly.length - i) % 3 == 0) {
        formatted += ',';
      }
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}