import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection_container.dart';
import 'apply_filters_page.dart';

class FollowUpClientsPage extends StatefulWidget {
  const FollowUpClientsPage({super.key});

  @override
  State<FollowUpClientsPage> createState() => _FollowUpClientsPageState();
}

class _FollowUpClientsPageState extends State<FollowUpClientsPage> {
  final ApiClient _apiClient = sl<ApiClient>();
  int _currentPage = 1;
  int _rowsPerPage = 20;
  List<Map<String, dynamic>> _clients = [];
  Map<String, dynamic>? _appliedFilters;
  bool _isLoading = false;
  String? _error;

  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();
  bool _hasShownEmptyMessage = false;

  final List<String> _columnHeaders = [
    'Sr#',
    'Mem ID',
    'CNIC',
    'Name',
    'Amount',
    'Due Date',
    'Status',
  ];

  final List<double> _columnWidths = [
    80,  // Sr#
    120, // Mem ID
    140, // CNIC
    120, // Name
    100, // Amount
    120, // Due Date
    100, // Status
  ];

  @override
  void initState() {
    super.initState();
    _headerScrollController.addListener(_syncHeaderToBody);
    _bodyScrollController.addListener(_syncBodyToHeader);
    _fetchFollowUpClients();
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

  Future<void> _fetchFollowUpClients() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final queryParams = {
        'sidx': 'Member_ID',
        'sord': 'DESC',
        'page': _currentPage,
        'rows': _rowsPerPage,
        'UserID': '91248',
        'Branch_id': _appliedFilters?['branchId'] ?? '',
        'Member_ID': _appliedFilters?['memberId'] ?? '',
        'Case_Date': '',
        'Case_DateTo': '',
        'Product_ID': _appliedFilters?['products'] != null && (_appliedFilters!['products'] as List).isNotEmpty 
                      ? (_appliedFilters!['products'] as List).join(',') 
                      : '',
        'Center_No': '',
        'Amount': '',
      };

      final response = await _apiClient.get(
        ApiEndpoints.getFollowUpClients,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['data'] is List) {
          final List<dynamic> list = data['data'];
          setState(() {
            _clients = list.map((e) => e as Map<String, dynamic>).toList();
            _hasShownEmptyMessage = false;
          });
        } else {
           setState(() {
            _clients = [];
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_error != null)
              Container(
                width: double.infinity,
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            _buildTableHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _clients.isEmpty
                      ? _buildEmptyState()
                      : _buildTableContent(),
            ),
            _buildPaginationFooter(),
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Follow Up Clients',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: _currentPage > 1
                            ? () {
                                setState(() {
                                  _currentPage--;
                                });
                                _fetchFollowUpClients();
                              }
                            : null,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '<<Previous',
                          style: TextStyle(
                            color: _currentPage > 1
                                ? AppColors.primary
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _openFilters(),
                        icon: Icon(
                          Icons.filter_list,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentPage++;
                          });
                          _fetchFollowUpClients();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Next>>',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
              child: Text(
                _columnHeaders[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTableContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _bodyScrollController,
      child: SizedBox(
        width: _totalColumnWidth,
        child: ListView.builder(
          itemCount: _clients.length,
          itemBuilder: (context, rowIndex) {
            final client = _clients[rowIndex];
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
                  String text = '';
                  
                  // Mappings
                  if (header == 'Sr#') {
                     text = ((_currentPage - 1) * _rowsPerPage + rowIndex + 1).toString();
                  } else {
                     String dataKey = _getDataKeyForHeader(header);
                     text = client[dataKey]?.toString() ?? '-';
                  }

                  return Container(
                    width: _columnWidths[colIndex],
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: Text(
                      text,
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
    switch (header) {
      case 'Mem ID':
        return 'Member_ID';
      case 'CNIC':
        return 'NIC_New';
      case 'Name':
        return 'PI_Name';
      case 'Amount':
        return 'OverDueAmount';
      case 'Due Date':
        return 'DueDate';
      case 'Status':
        return 'Status';
      default:
        return header.toLowerCase().replaceAll(' ', '');
    }
  }

  Widget _buildEmptyState() {
    // Show popup message when there's no data (only once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_clients.isEmpty && mounted && !_hasShownEmptyMessage) {
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
                '📋',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Follow Up Clients',
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
            onPressed: _currentPage > 1 && !_isLoading
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    _fetchFollowUpClients();
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
            onPressed: _isLoading
                ? null 
                : () {
                    setState(() {
                      _currentPage++;
                    });
                     _fetchFollowUpClients();
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
        builder: (context) => const ApplyFiltersPage(),
      ),
    );

    if (filters != null) {
      setState(() {
        _appliedFilters = filters;
        _clients = [];
        _currentPage = 1;
        _hasShownEmptyMessage = false; // Reset flag to show message again if needed
      });
      _fetchFollowUpClients();
    }
  }
}

