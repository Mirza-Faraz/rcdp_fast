import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection_container.dart';
import 'apply_filters_page.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({super.key});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  final ApiClient _apiClient = sl<ApiClient>();
  int _currentPage = 1;
  int _rowsPerPage = 20;
  List<Map<String, dynamic>> _approvals = [];
  Map<String, dynamic>? _appliedFilters; // Used to store applied filters for future API calls
  bool _isLoading = false;
  String? _error;

  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();
  bool _hasShownEmptyMessage = false;

  @override
  void initState() {
    super.initState();
    // Sync header and body horizontal scrolling
    _headerScrollController.addListener(_syncHeaderToBody);
    _bodyScrollController.addListener(_syncBodyToHeader);
    
    // Initial fetch
    _fetchApprovals();
  }

  void _syncHeaderToBody() {
    if (_bodyScrollController.hasClients &&
        _headerScrollController.offset != _bodyScrollController.offset) {
      _bodyScrollController.jumpTo(_headerScrollController.offset);
    }
  }

  void _syncBodyToHeader() {
    if (_headerScrollController.hasClients &&
        _bodyScrollController.offset != _headerScrollController.offset) {
      _headerScrollController.jumpTo(_bodyScrollController.offset);
    }
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    _bodyScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchApprovals() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Construct query parameters
      final queryParams = {
        'sidx': 'Member_ID', // Default sort column
        'sord': 'DESC',      // Default sort order
        'page': _currentPage,
        'rows': _rowsPerPage,
        'UserID': '91248',   // Hardcoded as per request example
        // Other parameters can be empty strings as per instruction
        'Branch_id': _appliedFilters?['branchId'] ?? '',
        'Member_ID': _appliedFilters?['memberId'] ?? '',
        'Case_Date': '',
        'Case_DateTo': '',
        'Product_ID': _appliedFilters?['products'] != null && (_appliedFilters!['products'] as List).isNotEmpty 
                      ? (_appliedFilters!['products'] as List).join(',') // Assuming join by comma if multiple
                      : '',
        'Center_No': '',
        'Approvel': '',
        'cnic': _appliedFilters?['cnic'] ?? '',
      };

      final response = await _apiClient.get(
        ApiEndpoints.getCaseList,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['data'] is List) {
          final List<dynamic> list = data['data'];
          setState(() {
            _approvals = list.map((e) => e as Map<String, dynamic>).toList();
            _hasShownEmptyMessage = false;
          });
        } else {
           setState(() {
            _approvals = [];
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load data (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading data: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                      child: _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : _approvals.isEmpty
                          ? _buildEmptyState()
                          : _buildTableContent(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Approvals',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => _openFilters(),
                icon: const Icon(
                  Icons.filter_alt,
                  color: AppColors.primary,
                  size: 32,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $_currentPage, $_rowsPerPage rows',
                style: TextStyle(
                  color: AppColors.primary.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _isLoading || _currentPage <= 1
                        ? null
                        : () {
                            setState(() {
                              _currentPage--;
                            });
                            _fetchApprovals();
                          },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '<<Previous',
                      style: TextStyle(
                        color: _currentPage > 1 ? AppColors.primary : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _isLoading 
                        ? null 
                        : () {
                            setState(() {
                              _currentPage++;
                            });
                             _fetchApprovals();
                          },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Next>>',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Define all column headers in sequence
  final List<String> _columnHeaders = [
    'Mem ID',
    'CNIC',
    'Name',
    'Amount',
    'Center No',
    'Donor Name',
    'Nominee Name',
    'Nominee CNIC',
    'Co Name',
    'Name As',
    'Status',
  ];

  // Define column widths (in pixels)
  final List<double> _columnWidths = [
    100, // Mem ID
    120, // CNIC
    120, // Name
    100, // Amount
    100, // Center No
    120, // Donor Name
    120, // Nominee Name
    120, // Nominee CNIC
    100, // Co Name
    100, // Name As
    100, // Status
  ];

  double get _totalColumnWidth => _columnWidths.fold(0, (sum, width) => sum + width);

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.primary,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _headerScrollController,
        child: Row(
          children: List.generate(_columnHeaders.length, (index) {
            return Container(
              width: _columnWidths[index],
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: _buildHeaderCell(_columnHeaders[index]),
            );
          }),
        ),
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
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTableContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _bodyScrollController,
      child: SizedBox(
        width: _totalColumnWidth,
        child: ListView.builder(
          itemCount: _approvals.length,
          itemBuilder: (context, rowIndex) {
            final approval = _approvals[rowIndex];
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: List.generate(_columnHeaders.length, (colIndex) {
                  final header = _columnHeaders[colIndex];
                  // Map header to data key
                  String dataKey = _getDataKeyForHeader(header);
                  return Container(
                    width: _columnWidths[colIndex],
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: Text(
                      approval[dataKey]?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getDataKeyForHeader(String header) {
    // Map display headers to data keys from API response
    switch (header) {
      case 'Mem ID':
        return 'Member_ID';
      case 'CNIC':
        return 'NIC_New';
      case 'Name':
        return 'PI_Name';
      case 'Amount':
        return 'OverDueAmount'; // Using OverDueAmount as Amount as per check
      case 'Center No':
        return 'Center_No'; // Might not be in response, but typical key
      case 'Donor Name':
        return 'Donor_Name'; // Guessing
      case 'Nominee Name':
        return 'Nominee_Name';
      case 'Nominee CNIC':
        return 'Nominee_CNIC';
      case 'Co Name':
        return 'Client_Careoff_Name'; // Close match
      case 'Name As':
        return 'Name_As'; // Guessing
      case 'Status':
        return 'Status'; // Guessing
      default:
        return header;
    }
  }

  Widget _buildEmptyState() {
    // Show popup message when there's no data (only once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_approvals.isEmpty && mounted && !_hasShownEmptyMessage) {
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
              child: Text(
                '📄',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Approvals',
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
        _currentPage = 1;
        _hasShownEmptyMessage = false; 
      });
      _fetchApprovals();
    }
  }
}

