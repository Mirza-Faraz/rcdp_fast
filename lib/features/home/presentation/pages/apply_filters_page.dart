import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/data/models/branch_model.dart';
import '../../../auth/data/models/product_model.dart';
import '../../../auth/data/models/credit_officer_model.dart';
import '../../../../core/constants/app_text_styles.dart';

enum FilterField {
  branchId,
  memberId,
  cnic,
  creditOfficer,
  product,
  groupId,
  caseDateFrom,
  caseDateTo,
  overdueAmount,
  distance,
  approvalStatus,
}

class ApplyFiltersPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFiltersApplied;
  final List<FilterField>? enabledFields;

  const ApplyFiltersPage({
    super.key, 
    this.onFiltersApplied,
    this.enabledFields,
  });

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
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _overDueAmountController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

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

  // Credit Officer selection
  List<CreditOfficerModel> _allCreditOfficers = [];
  String? _selectedCreditOfficerId;
  String? _selectedCreditOfficerName;
  bool _isCreditOfficerLoading = false;
  String? _creditOfficerError;
  bool _isCreditOfficerDropdownOpen = false;

  // Approval Status selection
  String? _selectedApprovalStatus;
  bool _isApprovalStatusDropdownOpen = false;
  final List<String> _approvalStatuses = ['APPROVED', 'PENDING', 'REJECTED', 'POSTED'];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadUserBranch();
    if (_selectedBranchId != null) {
      final branchId = int.parse(_selectedBranchId!);
      _fetchProducts(branchId);
      _fetchCreditOfficers(branchId);
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

  Future<void> _fetchCreditOfficers(int branchId) async {
    setState(() {
      _isCreditOfficerLoading = true;
      _creditOfficerError = null;
    });

    try {
      final authRepo = sl<AuthRepository>();
      final result = await authRepo.getCreditOfficers(branchId);

      result.fold(
        (failure) {
          setState(() {
            _creditOfficerError = failure.message;
          });
        },
        (officers) {
          setState(() {
            _allCreditOfficers = officers;
            // Clear selection if current selected officer is not in the new list
            if (_selectedCreditOfficerId != null && !officers.any((o) => o.userId == _selectedCreditOfficerId)) {
              _selectedCreditOfficerId = null;
              _selectedCreditOfficerName = null;
            }
          });
        },
      );
    } catch (e) {
      setState(() {
        _creditOfficerError = 'Failed to load credit officers. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCreditOfficerLoading = false;
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
    _dateFromController.dispose();
    _dateToController.dispose();
    _overDueAmountController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.enabledFields ?? [
      FilterField.branchId,
      FilterField.memberId,
      FilterField.creditOfficer,
      FilterField.product,
      FilterField.groupId,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Apply Filters',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            if (fields.contains(FilterField.branchId)) ...[
              _buildFilterField(label: 'Branch ID', child: _buildBranchDropdown()),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.memberId)) ...[
              _buildFilterField(
                label: 'Member ID',
                child: _buildTextField(controller: _memberIdController),
              ),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.caseDateFrom)) ...[
              _buildFilterField(
                label: 'Case Date From',
                child: _buildDateField(_dateFromController),
              ),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.caseDateTo)) ...[
              _buildFilterField(
                label: 'Case Date To',
                child: _buildDateField(_dateToController),
              ),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.creditOfficer)) ...[
              _buildFilterField(
                label: 'Credit Officer',
                child: _buildCreditOfficerDropdown(),
              ),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.product)) ...[
              _buildFilterField(label: 'Product', child: _buildProductDropdown()),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.groupId)) ...[
              _buildFilterField(
                label: 'Group Id',
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 150,
                    child: _buildTextField(controller: _groupIdController),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.overdueAmount)) ...[
              _buildFilterField(
                label: 'Over Due Amount',
                child: _buildTextField(controller: _overDueAmountController),
              ),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.distance)) ...[
              _buildFilterField(
                label: 'Distance (in meters)',
                child: _buildTextField(controller: _distanceController),
              ),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.approvalStatus)) ...[
              _buildFilterField(
                label: 'Approval Status',
                child: _buildApprovalStatusDropdown(),
              ),
              const SizedBox(height: 16),
            ],
            if (fields.contains(FilterField.cnic)) ...[
              _buildFilterField(
                label: 'CNIC',
                child: _buildTextField(controller: _cnicController),
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 16),
            _buildApplyButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterField({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            controller.text =
                '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400, width: 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.text.isEmpty ? '' : controller.text,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
            // No calendar icon in screenshot for these fields? 
            // The screenshot shows empty fields but I'll add an icon if it feels right. 
            // Wait, the screenshot has no icons inside the date fields, just empty white boxes.
          ],
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
          TextButton(onPressed: _loadUserBranch, child: const Text('Retry')),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _branchName?.toUpperCase() ?? 'SELECT BRANCH',
            style: TextStyle(
              color: _branchName == null ? Colors.grey.shade600 : AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, String? hintText}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
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
        border: Border.all(
          color: _isProductDropdownOpen ? AppColors.primary : Colors.grey.shade400, 
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isProductDropdownOpen = !_isProductDropdownOpen;
                if (_isProductDropdownOpen) {
                  _isCreditOfficerDropdownOpen = false;
                  _isApprovalStatusDropdownOpen = false;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedProductIds.isEmpty 
                          ? 'SELECT PRODUCT' 
                          : _selectedProductNames.first.toUpperCase(),
                      style: TextStyle(
                        color: _selectedProductIds.isEmpty ? Colors.grey.shade600 : AppColors.primary, 
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Icon(
                    _isProductDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, 
                    color: AppColors.primary,
                  ),
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
                        _selectedProductIds = [product.productId];
                        _selectedProductNames = [product.productDescription];
                        _isProductDropdownOpen = false;
                      });
                    },
                    child: Container(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.productDescription, 
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check, color: AppColors.primary, size: 18),
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

  Widget _buildCreditOfficerDropdown() {
    if (_isCreditOfficerLoading) {
      return const Center(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_creditOfficerError != null) {
      return Row(
        children: [
          Expanded(
            child: Text(_creditOfficerError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
          TextButton(onPressed: () {
            if (_selectedBranchId != null) {
              _fetchCreditOfficers(int.parse(_selectedBranchId!));
            }
          }, child: const Text('Retry')),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isCreditOfficerDropdownOpen ? AppColors.primary : Colors.grey.shade400, 
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isCreditOfficerDropdownOpen = !_isCreditOfficerDropdownOpen;
                if (_isCreditOfficerDropdownOpen) {
                  _isProductDropdownOpen = false;
                  _isApprovalStatusDropdownOpen = false;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedCreditOfficerId == null 
                          ? 'SELECT USER' 
                          : _selectedCreditOfficerName?.toUpperCase() ?? '',
                      style: TextStyle(
                        color: _selectedCreditOfficerId == null ? Colors.grey.shade600 : AppColors.primary, 
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Icon(
                    _isCreditOfficerDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, 
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (_isCreditOfficerDropdownOpen)
            Container(
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _allCreditOfficers.length,
                itemBuilder: (context, index) {
                  final officer = _allCreditOfficers[index];
                  final isSelected = _selectedCreditOfficerId == officer.userId;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCreditOfficerId = officer.userId;
                        _selectedCreditOfficerName = officer.userName;
                        _isCreditOfficerDropdownOpen = false;
                      });
                    },
                    child: Container(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              officer.userName, 
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check, color: AppColors.primary, size: 18),
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

  Widget _buildApprovalStatusDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isApprovalStatusDropdownOpen ? AppColors.primary : Colors.grey.shade400, 
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isApprovalStatusDropdownOpen = !_isApprovalStatusDropdownOpen;
                if (_isApprovalStatusDropdownOpen) {
                  _isProductDropdownOpen = false;
                  _isCreditOfficerDropdownOpen = false;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedApprovalStatus == null 
                          ? 'SELECT APPROVAL STATUS' 
                          : _selectedApprovalStatus!,
                      style: TextStyle(
                        color: _selectedApprovalStatus == null ? Colors.grey.shade600 : AppColors.primary, 
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Icon(
                    _isApprovalStatusDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, 
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (_isApprovalStatusDropdownOpen)
            Container(
              constraints: const BoxConstraints(maxHeight: 250),
              child: Column(
                children: _approvalStatuses.map((status) {
                  final isSelected = _selectedApprovalStatus == status;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedApprovalStatus = status;
                        _isApprovalStatusDropdownOpen = false;
                      });
                    },
                    child: Container(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              status, 
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check, color: AppColors.primary, size: 18),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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
            'creditOfficer': _selectedCreditOfficerId,
            'products': _selectedProductIds,
            'groupId': _groupIdController.text.trim(),
            'fromDate': _dateFromController.text.trim(),
            'toDate': _dateToController.text.trim(),
            'overDueAmount': _overDueAmountController.text.trim(),
            'distance': _distanceController.text.trim(),
            'cnic': _cnicController.text.trim(),
            'approvalStatus': _selectedApprovalStatus,
          };

          if (widget.onFiltersApplied != null) {
            widget.onFiltersApplied!(filters);
          }

          Navigator.pop(context, filters);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
        child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
