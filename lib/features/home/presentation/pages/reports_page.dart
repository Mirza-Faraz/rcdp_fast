import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'apply_filters_page.dart';

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
    if (_selectedReport == 'LDF Report') {
      return _buildLDFReportInputs();
    } else if (_selectedReport == 'Summary of Credit Activity Report') {
      return _buildSummaryCreditActivityInputs();
    } else {
      return _buildDateRangeInputs();
    }
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
      {bool hasDropdown = false}) {
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedReport == null
            ? null
            : () {
                // Get report action
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Get Report',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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
      debugPrint('Filters applied: $filters');
    }
  }
}




