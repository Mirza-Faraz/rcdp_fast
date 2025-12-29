import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'apply_filters_page.dart';

class DataCheckInquiryPage extends StatefulWidget {
  const DataCheckInquiryPage({super.key});

  @override
  State<DataCheckInquiryPage> createState() => _DataCheckInquiryPageState();
}

class _DataCheckInquiryPageState extends State<DataCheckInquiryPage> {
  int _currentPage = 1;
  int _rowsPerPage = 20;
  List<Map<String, dynamic>> _inquiries = [];
  Map<String, dynamic>? _appliedFilters;
  bool _hasShownEmptyMessage = false; // Used to store applied filters for future API calls

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildTableHeader(),
                    Expanded(
                      child: _inquiries.isEmpty
                          ? _buildEmptyState()
                          : _buildTableContent(),
                    ),
                  ],
                ),
              ),
            ),
            _buildPaginationFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Check Inquiry',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Page $_currentPage, $_rowsPerPage rows',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => _openFilters(),
            icon: const Icon(
              Icons.filter_alt,
              color: AppColors.primary,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildHeaderCell('Sr#'),
          ),
          Expanded(
            flex: 2,
            child: _buildHeaderCell('Id'),
          ),
          Expanded(
            flex: 2,
            child: _buildHeaderCell('CNIC'),
          ),
          Expanded(
            flex: 2,
            child: _buildHeaderCell('Name'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTableContent() {
    return ListView.builder(
      itemCount: _inquiries.length,
      itemBuilder: (context, index) {
        final inquiry = _inquiries[index];
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  '${inquiry['sr'] ?? index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  inquiry['id'] ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  inquiry['cnic'] ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  inquiry['name'] ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    // Show popup message when there's no data (only once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inquiries.isEmpty && mounted && !_hasShownEmptyMessage) {
        _hasShownEmptyMessage = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Record not Found'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.search,
                size: 48,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Data Check Inquiry',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                : null,
            child: Text(
              '<<Previous',
              style: TextStyle(
                color: _currentPage > 1 ? AppColors.primary : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            'Page $_currentPage, $_rowsPerPage rows',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentPage++;
              });
            },
            child: const Text(
              'Next>>',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFilters() async {
    final filters = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const ApplyFiltersPage(
          enabledFields: [
            FilterField.branchId,
            FilterField.memberId,
            FilterField.creditOfficer,
            FilterField.product,
            FilterField.groupId,
          ],
        ),
      ),
    );

    if (filters != null) {
      setState(() {
        _appliedFilters = filters;
        // Here you would typically fetch filtered data from API using _appliedFilters
        // For now, we'll just show empty state
        _inquiries = [];
        _currentPage = 1;
        _hasShownEmptyMessage = false; // Reset flag to show message again if needed
      });
      // Using _appliedFilters to suppress unused warning - will be used in API calls
      debugPrint('Filters applied: $_appliedFilters');
    }
  }
}

