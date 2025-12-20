import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/data/models/branch_model.dart';
import '../../../auth/data/models/product_model.dart';
import '../../../../core/constants/app_text_styles.dart';

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
  List<ProductModel> _allProducts = [];
  List<String> _selectedProductNames = [];
  List<int> _selectedProductIds = [];

  bool _isBranchLoading = false;
  String? _branchError;
  String? _branchName;

  bool _isProductLoading = false;
  String? _productError;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadUserBranch();
    if (_selectedBranchId != null) {
      _fetchProducts(int.parse(_selectedBranchId!));
    }
  }

  Future<void> _loadUserBranch() async {
    setState(() {
      _isBranchLoading = true;
      _branchError = null;
    });

    try {
      final authRepo = sl<AuthRepository>();
      final branchesResult = await authRepo.getSavedBranches();
      
      branchesResult.fold(
        (failure) {
          setState(() {
            _branchError = 'Failed to load branches.';
          });
        },
        (branches) {
          if (branches != null && branches.isNotEmpty) {
            setState(() {
              // Auto-select the first branch
              _selectedBranchId = branches.first.branchId.toString();
              _branchName = branches.first.branchName;
            });
          } else {
            setState(() {
              _branchError = 'No branches found for this user.';
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _branchError = 'Failed to load user branch.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBranchLoading = false;
        });
      }
    }
  }

  Future<void> _fetchProducts(int branchId) async {
    setState(() {
      _isProductLoading = true;
      _productError = null;
    });

    try {
      final authRepo = sl<AuthRepository>();
      final result = await authRepo.getProducts(branchId);

      result.fold(
        (failure) {
          setState(() {
            _productError = failure.message;
          });
        },
        (products) {
          setState(() {
            _allProducts = products;
            // Clear selection if current selected product is not in the new list
            if (_selectedProductIds.isNotEmpty && !products.any((ProductModel p) => _selectedProductIds.contains(p.productId))) {
              _selectedProductIds.clear();
              _selectedProductNames.clear();
            }
          });
        },
      );
    } catch (e) {
      setState(() {
        _productError = 'Failed to load products. Please try again.';
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
          TextButton(onPressed: _loadUserBranch, child: const Text('Retry')),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _branchName ?? 'No Branch',
        style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
      ),
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
          TextButton(onPressed: () {
            if (_selectedBranchId != null) {
              _fetchProducts(int.parse(_selectedBranchId!));
            }
          }, child: const Text('Retry')),
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
                      _selectedProductIds.isEmpty 
                          ? 'SELECT PRODUCT' 
                          : _selectedProductNames.first,
                      style: TextStyle(
                        color: _selectedProductIds.isEmpty ? Colors.grey.shade400 : Colors.black87, 
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _allProducts.length,
                itemBuilder: (context, index) {
                  final product = _allProducts[index];
                  final isSelected = _selectedProductIds.contains(product.productId);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        // Single selection logic
                        _selectedProductIds = [product.productId];
                        _selectedProductNames = [product.productDescription];
                        _isProductDropdownOpen = false;
                      });
                    },
                    child: Container(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(product.productDescription, style: const TextStyle(fontSize: 14, color: Colors.black87)),
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
            'products': _selectedProductIds,
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
