import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'client_detail_page.dart';
import 'already_saved_clients_page.dart';

class DisbursementPage extends StatefulWidget {
  const DisbursementPage({super.key});

  @override
  State<DisbursementPage> createState() => _DisbursementPageState();
}

class _DisbursementPageState extends State<DisbursementPage> {
  bool _searchByCNIC = true;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _clientNotFound = false;
  bool _showNameField = false;
  String? _foundCnic;
  String? _foundMemberId;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
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
                    const SizedBox(height: 20),
                    const Text(
                      'Disbursement',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create a new client or search your client through CNIC / Member ID.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSearchOptions(),
                    const SizedBox(height: 24),
                    if (_searchByCNIC)
                      _buildSearchField('Enter Client CNIC to Search')
                    else
                      _buildSearchField('Enter Client Member ID to Search'),
                    const SizedBox(height: 24),
                    if (_clientNotFound && !_showNameField) _buildNotFoundMessage(),
                    if (_showNameField) _buildNameField(),
                    const SizedBox(height: 32),
                    _buildOpenButton(),
                    if (_clientNotFound && !_showNameField) _buildBackToSearchButton(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
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
            'Disbursement',
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

  Widget _buildSearchOptions() {
    return Column(
      children: [
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: _searchByCNIC,
              onChanged: (value) {
                setState(() {
                  _searchByCNIC = true;
                  _searchController.clear();
                  _clientNotFound = false;
                  _showNameField = false;
                });
              },
              activeColor: AppColors.primary,
            ),
            const Text(
              'Search by CNIC',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Radio<bool>(
              value: false,
              groupValue: _searchByCNIC,
              onChanged: (value) {
                setState(() {
                  _searchByCNIC = false;
                  _searchController.clear();
                  _clientNotFound = false;
                  _showNameField = false;
                });
              },
              activeColor: AppColors.primary,
            ),
            const Text(
              'Search Member ID',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField(String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  Widget _buildNotFoundMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        'Client Not Found. Enter name as per CNIC to add new.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: TextEditingController(text: _foundCnic ?? _foundMemberId),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            readOnly: true,
            style: const TextStyle(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter name as per CNIC',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenButton() {
    if (_clientNotFound && !_showNameField) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_showNameField) {
            // Adding new client
            if (_nameController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter client name'),
                  backgroundColor: AppColors.primary,
                ),
              );
              return;
            }
            // Navigate to client detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientDetailPage(
                  cnic: _foundCnic,
                  memberId: _foundMemberId,
                  clientName: _nameController.text.trim(),
                ),
              ),
            );
          } else {
            _handleOpen();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          _showNameField ? 'Add Client' : 'Open',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSearchButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              _clientNotFound = false;
              _showNameField = false;
              _nameController.clear();
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Back to Search',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _handleOpen() {
    if (_searchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter ${_searchByCNIC ? "CNIC" : "Member ID"}'),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    // Simulate client search
    // In real app, this would be an API call
    final searchValue = _searchController.text.trim();
    
    // Check if client exists (mock logic - for demo, some CNICs exist)
    final clientExists = _checkClientExists(searchValue);
    
    if (clientExists) {
      // Navigate to client detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClientDetailPage(
            cnic: _searchByCNIC ? searchValue : null,
            memberId: _searchByCNIC ? null : searchValue,
            clientName: 'Test', // This would come from API
          ),
        ),
      );
    } else {
      setState(() {
        _clientNotFound = true;
        _showNameField = true;
        if (_searchByCNIC) {
          _foundCnic = searchValue;
          _foundMemberId = null;
        } else {
          _foundMemberId = searchValue;
          _foundCnic = null;
        }
      });
    }
  }

  bool _checkClientExists(String value) {
    // Mock: Check if client exists
    // For demo purposes, return true for certain values to show existing client flow
    // In real app, this would be an API call
    final existingClients = ['35202-4175458-5', '9042000003'];
    return existingClients.contains(value);
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: AppColors.primary,
                child: const Text(
                  'Client and Group Formation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlreadySavedClientsPage(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.white,
                child: Text(
                  'Already Saved Clients',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

