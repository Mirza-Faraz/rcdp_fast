import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../manager/reports_cubit.dart';
import 'apply_filters_page.dart';
import 'pdf_viewer_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String? _selectedReport;
  final TextEditingController _memberIdController = TextEditingController();
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _selectBranchController = TextEditingController();
  final TextEditingController _selectUserController = TextEditingController();
  
  int? _branchId;
  int? _userId;
  String? _branchName;
  String? _userName;
  List<dynamic> _branches = [];
  bool _isBranchLoading = false;

  final List<String> _reportTypes = [
    'LDF Report',
    'Client Ledger Report',
    'Summary Report',
    'Recovery Report',
    'Detail Recovery Report',
    'Center Wise Recovery Report',
    'Activity Report',
    'Summary of Credit Activity Report',
  ];

  @override
  void initState() {
    super.initState();
    debugPrint('ReportsPage: initState called');
    _loadUserBranch();
  }

  Future<void> _loadUserBranch() async {
    setState(() => _isBranchLoading = true);
    final authRepo = sl<AuthRepository>();
    
    // Load user description for user ID
    final userResult = await authRepo.getUserDescription();
    userResult.fold(
      (failure) => null,
      (userDesc) {
        if (userDesc != null) {
          setState(() {
            _userId = userDesc.userId;
            _userName = userDesc.userName;
            _selectUserController.text = userDesc.userName;
          });
        }
      },
    );

    final result = await authRepo.getSavedBranches();
    result.fold(
      (failure) => null,
      (branches) {
        if (branches != null && branches.isNotEmpty) {
          setState(() {
            _branches = branches;
            _branchId = branches.first.branchId;
            _branchName = branches.first.branchName;
            _selectBranchController.text = branches.first.branchName;
          });
        }
      },
    );
    setState(() => _isBranchLoading = false);
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _dateFromController.dispose();
    _dateToController.dispose();
    _selectBranchController.dispose();
    _selectUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportsCubit>(),
      child: BlocListener<ReportsCubit, ReportsState>(
        listener: (context, state) {
          if (state is ReportsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is ReportsLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PdfViewerPage(
                  pdfBytes: state.pdfBytes,
                  title: _selectedReport ?? 'Report',
                ),
              ),
            );
          }
        },
        child: Scaffold(
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
                        _buildReportSelection(),
                        const SizedBox(height: 16),
                        if (_selectedReport != null) _buildReportInputs(),
                        const SizedBox(height: 16),
                        _buildGetReportButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reports',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Check out different reports by adding up the information required below',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _reportTypes.map((report) {
        return RadioListTile<String>(
          title: Text(report),
          value: report,
          groupValue: _selectedReport,
          onChanged: (value) {
            debugPrint('ReportsPage: Selected report changed to: $value');
            setState(() {
              _selectedReport = value;
            });
          },
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildReportInputs() {
    if (_selectedReport == 'LDF Report' || _selectedReport == 'Client Ledger Report') {
      return _buildLDFReportInputs();
    } else if (_selectedReport == 'Summary of Credit Activity Report') {
      return _buildSummaryCreditActivityInputs();
    } else if (_selectedReport == 'Summary Report') {
      return _buildSummaryReportInputs();
    } else {
      return _buildDateRangeInputs();
    }
  }

  Widget _buildSummaryReportInputs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField('Select Branch', _selectBranchController,
              hasDropdown: true, onTap: _showBranchPicker),
          const SizedBox(height: 16),
          _buildInputField('Select User', _selectUserController,
              hasDropdown: true), // For now, showing logged in user
        ],
      ),
    );
  }

  void _showBranchPicker() {
    if (_branches.isEmpty) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Branch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _branches.length,
                  itemBuilder: (context, index) {
                    final branch = _branches[index];
                    return ListTile(
                      title: Text(branch.branchName),
                      onTap: () {
                        setState(() {
                          _branchId = branch.branchId;
                          _branchName = branch.branchName;
                          _selectBranchController.text = branch.branchName;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLDFReportInputs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField('Member ID', _memberIdController),
        ],
      ),
    );
  }

  Widget _buildSummaryCreditActivityInputs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField('Select Branch', _selectBranchController,
              hasDropdown: true),
          const SizedBox(height: 16),
          _buildInputField('Select User', _selectUserController,
              hasDropdown: true),
          const SizedBox(height: 16),
          _buildDateInputField('Date From', _dateFromController),
          const SizedBox(height: 16),
          _buildDateInputField('Date To', _dateToController),
        ],
      ),
    );
  }

  Widget _buildDateRangeInputs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateInputField('Date From', _dateFromController),
          const SizedBox(height: 16),
          _buildDateInputField('Date To', _dateToController),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool hasDropdown = false, VoidCallback? onTap}) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              onTap: onTap,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixIcon: hasDropdown
                    ? const Icon(Icons.arrow_drop_down, color: Colors.grey)
                    : null,
              ),
              readOnly: hasDropdown,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInputField(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                controller.text =
                    '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
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
                    controller.text.isEmpty ? 'DD/MM/YYYY' : controller.text,
                    style: TextStyle(
                      color: controller.text.isEmpty
                          ? Colors.grey.shade400
                          : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGetReportButton() {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final isLoading = state is ReportsLoading || _isBranchLoading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_selectedReport == null || isLoading)
                ? null
                : () {
                    if (_selectedReport == 'Client Ledger Report') {
                      final memberIdStr = _memberIdController.text.trim();
                      if (memberIdStr.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter Member ID')),
                        );
                        return;
                      }

                      final int? memberId = int.tryParse(memberIdStr);
                      if (memberId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid Member ID')),
                        );
                        return;
                      }

                      if (_branchId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Branch information not found. Please try again.')),
                        );
                        _loadUserBranch();
                        return;
                      }

                      debugPrint('ReportsPage: Fetching Client Ledger Report with Member ID: $memberId and Branch ID: $_branchId');
                      context.read<ReportsCubit>().fetchClientLedgerReport(
                            memberId: memberId,
                            branchId: _branchId!,
                          );
                    } else if (_selectedReport == 'LDF Report') {
                      final memberIdStr = _memberIdController.text.trim();
                      if (memberIdStr.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter Member ID')),
                        );
                        return;
                      }

                      final int? memberId = int.tryParse(memberIdStr);
                      if (memberId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid Member ID')),
                        );
                        return;
                      }

                      if (_branchId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Branch information not found')),
                        );
                        return;
                      }

                      debugPrint('ReportsPage: Fetching LDF Report with DisbursID: $memberId and Branch ID: $_branchId');
                      context.read<ReportsCubit>().fetchLdfReport(
                            disbursId: memberId,
                            branchId: _branchId!,
                          );
                    } else if (_selectedReport == 'Summary Report') {
                      if (_branchId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a branch')),
                        );
                        return;
                      }

                      if (_userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User information not found')),
                        );
                        return;
                      }

                      debugPrint('ReportsPage: Fetching Summary Report with Branch ID: $_branchId and User ID: $_userId');
                      context.read<ReportsCubit>().fetchSummaryReport(
                            branchId: _branchId!,
                            userId: _userId!,
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fetching $_selectedReport is not implemented yet.')),
                      );
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
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Get Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
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
      debugPrint('Filters applied: $filters');
    }
  }
}




