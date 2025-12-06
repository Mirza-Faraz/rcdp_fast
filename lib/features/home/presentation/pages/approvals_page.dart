import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'apply_filters_page.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({super.key});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  int _currentPage = 1;
  int _rowsPerPage = 20;
  List<Map<String, dynamic>> _approvals = [];
  Map<String, dynamic>? _appliedFilters; // Used to store applied filters for future API calls
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();
  bool _hasShownEmptyMessage = false;

  @override
  void initState() {
    super.initState();
    // Sync header and body horizontal scrolling
    _headerScrollController.addListener(_syncHeaderToBody);
    _bodyScrollController.addListener(_syncBodyToHeader);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTableHeader(),
            Expanded(
              child: _approvals.isEmpty
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Approvals',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 22,
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: _currentPage > 1
                            ? () {
                                setState(() {
                                  _currentPage--;
                                });
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
    return ListView.builder(
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _bodyScrollController,
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
          ),
        );
      },
    );
  }

  String _getDataKeyForHeader(String header) {
    // Map display headers to data keys
    switch (header) {
      case 'Mem ID':
        return 'memId';
      case 'CNIC':
        return 'cnic';
      case 'Name':
        return 'name';
      case 'Amount':
        return 'amount';
      case 'Center No':
        return 'centerNo';
      case 'Donor Name':
        return 'donorName';
      case 'Nominee Name':
        return 'nomineeName';
      case 'Nominee CNIC':
        return 'nomineeCnic';
      case 'Co Name':
        return 'coName';
      case 'Name As':
        return 'nameAs';
      case 'Status':
        return 'status';
      default:
        return header.toLowerCase().replaceAll(' ', '');
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
        builder: (context) => const ApplyFiltersPage(),
      ),
    );

    if (filters != null) {
      setState(() {
        _appliedFilters = filters;
        // Here you would typically fetch filtered data from API using _appliedFilters
        // For now, we'll just show empty state
        _approvals = [];
        _currentPage = 1;
        _hasShownEmptyMessage = false; // Reset flag to show message again if needed
      });
      // Using _appliedFilters to suppress unused warning - will be used in API calls
      debugPrint('Filters applied: $_appliedFilters');
    }
  }
}

