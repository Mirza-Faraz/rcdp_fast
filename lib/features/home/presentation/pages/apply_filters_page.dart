import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../injection_container.dart';

class ApplyFiltersPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFiltersApplied;

  const ApplyFiltersPage({super.key, this.onFiltersApplied});

  @override
  State<ApplyFiltersPage> createState() => _ApplyFiltersPageState();
}

class _ApplyFiltersPageState extends State<ApplyFiltersPage> {
  final ApiClient _apiClient = sl<ApiClient>();

  String? _selectedBranchId;
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _creditOfficerController = TextEditingController();
  final TextEditingController _groupIdController = TextEditingController();

  List<String> _selectedProducts = [];
  bool _isProductDropdownOpen = false;

  // Products and branches loaded from APIs
  List<String> _allProducts = [];
  List<String> _branches = ['SELECT BRANCH'];

  bool _isBranchLoading = false;
  String? _branchError;

  bool _isProductLoading = false;
  String? _productError;

  @override
  void initState() {
    super.initState();
    _fetchBranches();
    _fetchProducts();
  }

  Future<void> _fetchBranches() async {
    setState(() {
      _isBranchLoading = true;
      _branchError = null;
    });

    try {
      final response = await _apiClient.post(ApiEndpoints.getBranchDropDown);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final List<dynamic> list = (data is Map && data['data'] is List) ? data['data'] as List : <dynamic>[];

        final names = list.whereType<Map<String, dynamic>>().map((e) => e['BranchID_Name']?.toString() ?? '').where((name) => name.isNotEmpty).toList();

        setState(() {
          _branches = ['SELECT BRANCH', ...names];
        });
      } else {
        setState(() {
          _branchError = 'Failed to load branches (${response.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        if (e is ServerException) {
          _branchError = e.message;
        } else if (e is NetworkException) {
          _branchError = e.message;
        } else {
          _branchError = 'Failed to load branches. Please try again.';
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBranchLoading = false;
        });
      }
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isProductLoading = true;
      _productError = null;
    });

    try {
      final response = await _apiClient.get(ApiEndpoints.getProductDropDown);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final List<dynamic> list = (data is Map && data['data'] is List) ? data['data'] as List : <dynamic>[];

        final names = list.whereType<Map<String, dynamic>>().map((e) => e['Product_Description']?.toString() ?? '').where((name) => name.isNotEmpty).toList();

        setState(() {
          _allProducts = names;
        });
      } else {
        setState(() {
          _productError = 'Failed to load products (${response.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        if (e is ServerException) {
          _productError = e.message;
        } else if (e is NetworkException) {
          _productError = e.message;
        } else {
          _productError = 'Failed to load products. Please try again.';
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProductLoading = false;
        });
      }
    }
  }

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
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 24),
            _buildFilterField(label: 'Branch ID', child: _buildBranchDropdown()),
            const SizedBox(height: 16),
            _buildFilterField(
              label: 'Member ID',
              child: _buildTextField(controller: _memberIdController),
            ),
            const SizedBox(height: 16),
            _buildFilterField(
              label: 'Credit Officer',
              child: _buildTextField(controller: _creditOfficerController, hintText: 'Select Credit Officer', hasDropdownIcon: true),
            ),
            const SizedBox(height: 16),
            _buildFilterField(label: 'Product', child: _buildProductDropdown()),
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

  Widget _buildFilterField({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required Function(String?) onChanged}) {
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
              child: Text(item, style: TextStyle(color: item == 'SELECT BRANCH' ? Colors.grey : Colors.black87, fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBranchDropdown() {
    if (_isBranchLoading) {
      return const Center(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_branchError != null) {
      return Row(
        children: [
          Expanded(
            child: Text(_branchError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
          TextButton(onPressed: _fetchBranches, child: const Text('Retry')),
        ],
      );
    }

    return _buildDropdown(
      value: _selectedBranchId ?? 'SELECT BRANCH',
      items: _branches,
      onChanged: (value) {
        setState(() {
          _selectedBranchId = value == 'SELECT BRANCH' ? null : value;
        });
      },
    );
  }

  Widget _buildTextField({required TextEditingController controller, String? hintText, bool hasDropdownIcon = false, VoidCallback? onTap}) {
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
          suffixIcon: hasDropdownIcon ? const Icon(Icons.arrow_drop_down, color: Colors.grey) : null,
        ),
        readOnly: onTap != null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildProductDropdown() {
    if (_isProductLoading) {
      return const Center(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_productError != null) {
      return Row(
        children: [
          Expanded(
            child: Text(_productError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
          TextButton(onPressed: _fetchProducts, child: const Text('Retry')),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _isProductDropdownOpen ? AppColors.primary : Colors.grey.shade300, width: _isProductDropdownOpen ? 2 : 1),
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
                      _selectedProducts.isEmpty ? 'SELECT PRODUCT' : '${_selectedProducts.length} Selected',
                      style: TextStyle(color: _selectedProducts.isEmpty ? Colors.grey.shade400 : Colors.black87, fontSize: 14),
                    ),
                  ),
                  Icon(_isProductDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.grey),
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
                      color: _selectedProducts.length == _allProducts.length ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedProducts.length == _allProducts.length ? 'Deselect All' : 'Select All',
                              style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (_selectedProducts.length == _allProducts.length) const Icon(Icons.check, color: AppColors.primary, size: 20),
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
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(product, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                                ),
                                if (isSelected) const Icon(Icons.check, color: AppColors.primary, size: 20),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
