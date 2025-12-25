import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../manager/loan_tracking_cubit.dart';
import '../../data/models/loan_tracking_model.dart';
import 'apply_filters_page.dart';

class LoanTrackingListPage extends StatefulWidget {
  const LoanTrackingListPage({super.key});

  @override
  State<LoanTrackingListPage> createState() => _LoanTrackingListPageState();
}

class _LoanTrackingListPageState extends State<LoanTrackingListPage> {
  int _currentPage = 1;
  final int _pageSize = 20;
  List<LoanTrackingModel> _loans = [];
  Map<String, dynamic>? _appliedFilters;
  bool _hasShownEmptyMessage = false;
  bool _isInitialLoad = true;
  late LoanTrackingCubit _cubit;

  final List<String> _columnHeaders = [
    'Sr#',
    'CNIC',
    'Id',
    'Name',
    'Amount',
    'Is Approved',
    'Is Posted',
    'Approval Progress',
    'Client Status'
  ];

  final List<double> _columnWidths = [
    60, // Sr#
    140, // CNIC
    120, // Id
    120, // Name
    120, // Amount
    120, // Is Approved
    120, // Is Posted
    140, // Approval Progress
    180, // Client Status (longer text)
  ];

  @override
  void initState() {
    super.initState();
    _cubit = sl<LoanTrackingCubit>();
    _fetchData();
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading data...', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<void> _fetchData() async {
    final localDataSource = sl<AuthLocalDataSource>();
    final userDesc = await localDataSource.getUserDescription();
    final branches = await localDataSource.getBranches();

    if (userDesc != null && branches != null && branches.isNotEmpty) {
      _cubit.fetchLoanTrackingList(
        userId: userDesc.userId,
        branchId: branches[0].branchId,
        page: _currentPage,
        rows: _pageSize,
        sidx: 'member_id',
        sord: 'DESC',
        memberId: _appliedFilters?['memberId']?.toString(),
        cnic: _appliedFilters?['cnic']?.toString(),
        productId: _appliedFilters?['productId']?.toString(),
        centerNo: _appliedFilters?['centerNo']?.toString(),
        caseDate: _appliedFilters?['caseDate']?.toString(),
        caseDateTo: _appliedFilters?['caseDateTo']?.toString(),
        approvel: _appliedFilters?['approval']?.toString(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: BlocConsumer<LoanTrackingCubit, LoanTrackingState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is LoanTrackingLoading) {
              _showLoadingDialog();
            } else if (state is LoanTrackingError) {
              _hideLoadingDialog();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            } else if (state is LoanTrackingLoaded) {
              _hideLoadingDialog();
              setState(() {
                _loans = state.loans;
                _isInitialLoad = false;
              });
              if (_loans.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Record Found'),
                    backgroundColor: AppColors.primary,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 1120,
                      child: Column(
                        children: [
                          _buildTableHeader(),
                          Expanded(
                            child: state is LoanTrackingLoading && _loans.isEmpty
                                ? const Center(child: CircularProgressIndicator())
                                : (_loans.isEmpty && !_isInitialLoad)
                                    ? _buildEmptyState()
                                    : _buildTableContent(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildPaginationFooter(),
              ],
            );
          },
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Loan Tracking',
                        style: TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Page $_currentPage, ${_loans.length} rows', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
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
                                _fetchData();
                              }
                            : null,
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Text(
                          '<<Previous',
                          style: TextStyle(
                              color: _currentPage > 1
                                  ? AppColors.primary
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _openFilters(),
                        icon: Icon(Icons.filter_list,
                            color: AppColors.primary, size: 24),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      TextButton(
                        onPressed: _loans.length == _pageSize
                            ? () {
                                setState(() {
                                  _currentPage++;
                                });
                                _fetchData();
                              }
                            : null,
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Text(
                          'Next>>',
                          style: TextStyle(
                              color: _loans.length == _pageSize
                                  ? AppColors.primary
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
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

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.primary,
      child: Row(
        children: List.generate(_columnHeaders.length, (index) {
          return Container(
            width: _columnWidths[index],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              _columnHeaders[index],
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTableContent() {
    return ListView.builder(
      itemCount: _loans.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, rowIndex) {
        final loan = _loans[rowIndex];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildCell(loan.srNo, 0),
              _buildCell(loan.cnic, 1),
              _buildCell(loan.clientId, 2),
              _buildCell(loan.clientName, 3),
              _buildCell(loan.amount, 4),
              _buildCell(loan.isApproved, 5),
              _buildCell(loan.isPosted, 6),
              _buildCell(loan.approvalProgress, 7),
              _buildCell(loan.clientStatus, 8),
            ],
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
          color: (colIndex > 0 && colIndex < 4) ? AppColors.primary : Colors.black87,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _openFilters() async {
    final filters = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ApplyFiltersPage()),
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

  Widget _buildEmptyState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_loans.isEmpty && mounted && !_hasShownEmptyMessage) {
        _hasShownEmptyMessage = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Record not Found'), backgroundColor: AppColors.primary, duration: const Duration(seconds: 2)));
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
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('📝', style: TextStyle(fontSize: 48))),
          ),
          const SizedBox(height: 16),
          const Text(
            'Loan Tracking',
            style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
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
                    _fetchData();
                  }
                : null,
            child: Text(
              '<<Previous',
              style: TextStyle(color: _currentPage > 1 ? AppColors.primary : Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          Text('Page $_currentPage, ${_loans.length} rows', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          TextButton(
            onPressed: _loans.length == _pageSize
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    _fetchData();
                  }
                : null,
            child: Text(
              'Next>>',
              style: TextStyle(color: _loans.length == _pageSize ? AppColors.primary : Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
