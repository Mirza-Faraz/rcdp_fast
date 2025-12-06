import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ApplyFiltersPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFiltersApplied;

  const ApplyFiltersPage({
    super.key,
    this.onFiltersApplied,
  });

  @override
  State<ApplyFiltersPage> createState() => _ApplyFiltersPageState();
}

class _ApplyFiltersPageState extends State<ApplyFiltersPage> {
  String? _selectedBranchId;
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _creditOfficerController = TextEditingController();
  final TextEditingController _groupIdController = TextEditingController();

  List<String> _selectedProducts = [];
  bool _isProductDropdownOpen = false;

  // All available products
  final List<String> _allProducts = [
    'FFOSP RCDP',
    'Gold-BPMM',
    'PMYBL12',
    'PMYBL24',
    'PMYBL 36',
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
    'Renewable energy',
    'IFL Conv Monthly',
    'IFL Conv 6Monthly',
    'IFL2 Conv Monthly',
    'IFL2 Conv 6Monthly',
    'SME24',
    'SHS (C1)',
  ];

  // Sample branch options
  final List<String> _branches = [
    'SELECT BRANCH',
    'Multan 1',
    'Multan 2',
    'Lahore 1',
    'Karachi 1',
    'Islamabad 1',
  ];

  @override
  void dispose() {
    _memberIdController.dispose();
    _cnicController.dispose();
    _creditOfficerController.dispose();
    _groupIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Apply Filters',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildFilterField(
              label: 'Branch ID',
              child: _buildDropdown(
                value: _selectedBranchId ?? 'SELECT BRANCH',
                items: _branches,
                onChanged: (value) {
                  setState(() {
                    _selectedBranchId = value == 'SELECT BRANCH' ? null : value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterField(
              label: 'Member ID',
              child: _buildTextField(controller: _memberIdController),
            ),
            const SizedBox(height: 16),
            _buildFilterField(
              label: 'Credit Officer',
              child: _buildTextField(
                controller: _creditOfficerController,
                hintText: 'Select Credit Officer',
                hasDropdownIcon: true,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterField(
              label: 'Product',
              child: _buildProductDropdown(),
            ),
            const SizedBox(height: 16),
            _buildFilterField(
              label: 'Group Id',
              child: _buildTextField(controller: _groupIdController),
            ),
            const SizedBox(height: 16),
            _buildFilterField(
              label: 'CNIC',
              child: _buildTextField(controller: _cnicController),
            ),
            const SizedBox(height: 32),
            _buildApplyButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterField({
    required String label,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: item == 'SELECT BRANCH' ? Colors.grey : Colors.black87,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    bool hasDropdownIcon = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          suffixIcon: hasDropdownIcon
              ? const Icon(Icons.arrow_drop_down, color: Colors.grey)
              : null,
        ),
        readOnly: onTap != null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildProductDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isProductDropdownOpen
              ? AppColors.primary
              : Colors.grey.shade300,
          width: _isProductDropdownOpen ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isProductDropdownOpen = !_isProductDropdownOpen;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedProducts.isEmpty
                          ? 'SELECT PRODUCT'
                          : '${_selectedProducts.length} Selected',
                      style: TextStyle(
                        color: _selectedProducts.isEmpty
                            ? Colors.grey.shade400
                            : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    _isProductDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (_isProductDropdownOpen)
            Container(
              constraints: const BoxConstraints(maxHeight: 250),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Select All option
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_selectedProducts.length == _allProducts.length) {
                          _selectedProducts.clear();
                        } else {
                          _selectedProducts = List<String>.from(_allProducts);
                        }
                      });
                    },
                    child: Container(
                      color: _selectedProducts.length == _allProducts.length
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedProducts.length == _allProducts.length
                                  ? 'Deselect All'
                                  : 'Select All',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_selectedProducts.length == _allProducts.length)
                            const Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // Product list
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _allProducts.length,
                      itemBuilder: (context, index) {
                        final product = _allProducts[index];
                        final isSelected = _selectedProducts.contains(product);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedProducts.remove(product);
                              } else {
                                _selectedProducts.add(product);
                              }
                            });
                          },
                          child: Container(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final filters = {
            'branchId': _selectedBranchId,
            'memberId': _memberIdController.text.trim(),
            'creditOfficer': _creditOfficerController.text.trim(),
            'products': _selectedProducts,
            'groupId': _groupIdController.text.trim(),
            'cnic': _cnicController.text.trim(),
          };

          if (widget.onFiltersApplied != null) {
            widget.onFiltersApplied!(filters);
          }

          Navigator.pop(context, filters);
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
          'Apply Filters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}

