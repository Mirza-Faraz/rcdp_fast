import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'client_detail_page.dart';
import 'apply_filters_page.dart';

class AlreadySavedClientsPage extends StatefulWidget {
  const AlreadySavedClientsPage({super.key});

  @override
  State<AlreadySavedClientsPage> createState() => _AlreadySavedClientsPageState();
}

class _AlreadySavedClientsPageState extends State<AlreadySavedClientsPage> {
  int _currentPage = 1;
  List<Map<String, dynamic>> _clients = [];
  Map<String, dynamic>? _appliedFilters;
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();
  bool _hasShownEmptyMessage = false;

  final List<String> _columnHeaders = [
    'Sr#',
    'Client Id',
    'Client Name',
    'Client Cnic',
  ];

  final List<double> _columnWidths = [
    60,  // Sr#
    140, // Client Id
    150, // Client Name
    160, // Client Cnic
  ];

  @override
  void initState() {
    super.initState();
    _headerScrollController.addListener(_syncHeaderToBody);
    _bodyScrollController.addListener(_syncBodyToHeader);
    _loadSampleData();
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

  void _loadSampleData() {
    setState(() {
      _clients = [
        {
          'sr': '1',
          'clientId': '9042000003',
          'clientName': 'Test',
          'clientCnic': '35202-4175458-5',
        },
      ];
    });
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
              child: _clients.isEmpty
                  ? _buildEmptyState()
                  : _buildTableContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Already Saved Clients',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }


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
    return ListView.builder(
      itemCount: _clients.length,
      itemBuilder: (context, rowIndex) {
        final client = _clients[rowIndex];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientDetailPage(
                  cnic: client['clientCnic'],
                  memberId: client['clientId'],
                  clientName: client['clientName'],
                ),
              ),
            );
          },
          child: Container(
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
                  String dataKey = _getDataKeyForHeader(header);
                  return Container(
                    width: _columnWidths[colIndex],
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: Text(
                      client[dataKey]?.toString() ?? '-',
                      style: TextStyle(
                        fontSize: 14,
                        color: (header == 'Client Id' || 
                                header == 'Client Name' || 
                                header == 'Client Cnic')
                            ? AppColors.primary
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDataKeyForHeader(String header) {
    switch (header) {
      case 'Sr#':
        return 'sr';
      case 'Client Id':
        return 'clientId';
      case 'Client Name':
        return 'clientName';
      case 'Client Cnic':
        return 'clientCnic';
      default:
        return header.toLowerCase().replaceAll(' ', '');
    }
  }

  Widget _buildEmptyState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_clients.isEmpty && mounted && !_hasShownEmptyMessage) {
        _hasShownEmptyMessage = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Record not Found'),
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });

    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'No saved clients found',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
          ),
        ),
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
        _hasShownEmptyMessage = false;
      });
      debugPrint('Filters applied: $_appliedFilters');
    }
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
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.white,
                child: Text(
                  'Client and Group Formation',
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
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: AppColors.primary,
                child: const Text(
                  'Already Saved Clients',
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
        ],
      ),
    );
  }
}

