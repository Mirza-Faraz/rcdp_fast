import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../injection_container.dart';

class RecoveryFormPage extends StatefulWidget {
  const RecoveryFormPage({super.key});

  @override
  State<RecoveryFormPage> createState() => _RecoveryFormPageState();
}

class _RecoveryFormPageState extends State<RecoveryFormPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ApiClient _apiClient = sl<ApiClient>();

  bool _searchForLastRecovery = false;
  String _selectedOption = 'Member ID';
  DateTime? _selectedDate;
  String? _selectedProduct;
  bool _isProductDropdownOpen = false;

  // Product dropdown data loaded from API
  List<_ProductItem> _products = [];
  bool _isLoadingProducts = false;
  String? _productError;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoadingProducts = true;
      _productError = null;
    });

    try {
      final response = await _apiClient.get(ApiEndpoints.getProductDropDown);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final List<dynamic> list = (data is Map && data['data'] is List) ? data['data'] as List : <dynamic>[];

        final products = list.whereType<Map<String, dynamic>>().map(_ProductItem.fromJson).toList();

        if (mounted) {
          setState(() {
            _products = products;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _productError = 'Failed to load products (${response.statusCode}).';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (e is ServerException) {
            _productError = e.message;
          } else if (e is NetworkException) {
            _productError = e.message;
          } else {
            _productError = 'Failed to load products. Please try again.';
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _productController.dispose();
    _searchController.dispose();
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
                    _buildDateField(),
                    const SizedBox(height: 16),
                    _buildProductField(),
                    const SizedBox(height: 16),
                    _buildSearchCheckbox(),
                    const SizedBox(height: 16),
                    _buildRadioButtons(),
                    const SizedBox(height: 16),
                    _buildSearchField(),
                    const SizedBox(height: 32),
                    _buildSearchButton(),
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
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0), bottomRight: Radius.circular(20), topLeft: Radius.circular(0), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recovery Form',
                        style: TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('Fill out this recovery form to update information', style: TextStyle(color: Colors.black87, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
                _dateController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dateController.text.isEmpty ? 'DD/MM/YYYY' : _dateController.text,
                  style: TextStyle(color: _dateController.text.isEmpty ? Colors.grey.shade400 : Colors.black87, fontSize: 14),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        if (_isLoadingProducts)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else if (_productError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(_productError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
                TextButton(onPressed: _fetchProducts, child: const Text('Retry')),
              ],
            ),
          )
        else
          Container(
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
                            _selectedProduct ?? 'Select Product',
                            style: TextStyle(color: _selectedProduct == null ? Colors.grey.shade400 : Colors.black87, fontSize: 14),
                          ),
                        ),
                        Icon(_isProductDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                if (_isProductDropdownOpen)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        final isSelected = _selectedProduct == product.description;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedProduct = product.description;
                              _productController.text = product.description;
                              _isProductDropdownOpen = false;
                            });
                          },
                          child: Container(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(product.description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
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
    );
  }

  Widget _buildSearchCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _searchForLastRecovery,
          onChanged: (value) {
            setState(() {
              _searchForLastRecovery = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        const Text('Search for Last Recovery', style: TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  Widget _buildRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<String>(
          title: const Text('Member ID'),
          value: 'Member ID',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          title: const Text('Center Number'),
          value: 'Center Number',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter ${_selectedOption}',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            // Add action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Search action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Search', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ProductItem {
  final int id;
  final String description;

  _ProductItem({required this.id, required this.description});

  factory _ProductItem.fromJson(Map<String, dynamic> json) {
    return _ProductItem(
      id: json['Product_ID'] is int ? json['Product_ID'] as int : int.tryParse(json['Product_ID']?.toString() ?? '0') ?? 0,
      description: json['Product_Description']?.toString() ?? '',
    );
  }
}
