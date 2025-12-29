import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../data/models/already_saved_client_model.dart';
import '../../presentation/manager/already_saved_clients_cubit.dart';
import '../../../../features/auth/data/datasources/auth_local_data_source.dart';
import 'client_detail_page.dart';
import 'apply_filters_page.dart';

class AlreadySavedClientsPage extends StatefulWidget {
  const AlreadySavedClientsPage({super.key});

  @override
  State<AlreadySavedClientsPage> createState() => _AlreadySavedClientsPageState();
}

class _AlreadySavedClientsPageState extends State<AlreadySavedClientsPage> {
  int _currentPage = 1;
  static const int _pageSize = 20;
  List<AlreadySavedClientModel> _clients = [];
  Map<String, dynamic>? _appliedFilters;
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();
  bool _hasShownEmptyMessage = false;
  late AlreadySavedClientsCubit _cubit;

  final List<String> _columnHeaders = [
    'Sr#',
    'Client Id',
    'Client Name',
    'Client Cnic',
  ];

  final List<double> _columnWidths = [
    60, // Sr#
    140, // Client Id
    150, // Client Name
    160, // Client Cnic
  ];

  @override
  void initState() {
    super.initState();
    _headerScrollController.addListener(_syncHeaderToBody);
    _bodyScrollController.addListener(_syncBodyToHeader);
    _cubit = sl<AlreadySavedClientsCubit>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final localDataSource = sl<AuthLocalDataSource>();
    final userDesc = await localDataSource.getUserDescription();
    final branches = await localDataSource.getBranches();

    if (userDesc != null && branches != null && branches.isNotEmpty) {
      _cubit.fetchAlreadySavedClients(
        userId: userDesc.userId,
        branchId: branches[0].branchId,
        page: _currentPage,
        rows: _pageSize,
        memberId: _appliedFilters?['memberId']?.toString(),
        cnic: _appliedFilters?['cnic']?.toString(),
        centerNo: _appliedFilters?['centerNo']?.toString(),
        productId: _appliedFilters?['productId']?.toString(),
        caseDate: _appliedFilters?['fromDate']?.toString(),
        caseDateTo: _appliedFilters?['toDate']?.toString(),
      );
    }
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
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: BlocConsumer<AlreadySavedClientsCubit, AlreadySavedClientsState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is AlreadySavedClientsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AlreadySavedClientsLoaded) {
              _clients = state.clients;
            }

            return Column(
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
                          child: state is AlreadySavedClientsLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _clients.isEmpty
                                  ? _buildEmptyState()
                                  : _buildTableContent(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_clients.isNotEmpty || _currentPage > 1) _buildPagination(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Already Saved Clients',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  cnic: client.clientCnic,
                  memberId: client.clientId,
                  clientName: client.clientName,
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
                children: [
                  _buildCell(client.srNo, 0),
                  _buildCell(client.clientId, 1),
                  _buildCell(client.clientName, 2),
                  _buildCell(client.clientCnic, 3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell(String text, int colIndex) {
    return Container(
      width: _columnWidths[colIndex],
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: (colIndex > 0) ? AppColors.primary : Colors.black87,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
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

  Widget _buildPagination() {
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
                    _fetchData();
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
            'Page $_currentPage',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: _clients.length == _pageSize
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    _fetchData();
                  }
                : null,
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
        _currentPage = 1;
        _hasShownEmptyMessage = false;
      });
      _fetchData();
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

