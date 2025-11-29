import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DataDetailPage extends StatefulWidget {
  final String title;
  final String dataType;

  const DataDetailPage({
    super.key,
    required this.title,
    required this.dataType,
  });

  @override
  State<DataDetailPage> createState() => _DataDetailPageState();
}

class _DataDetailPageState extends State<DataDetailPage> {
  bool _isLoading = true;
  String? _selectedBranch;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTrackingPage = widget.dataType == 'clients_nearby';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isTrackingPage ? _buildTrackingPage() : _buildDataPage(),
    );
  }

  Widget _buildTrackingPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Branch',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Branch'),
                value: _selectedBranch,
                items: ['Branch 1', 'Branch 2', 'Branch 3']
                    .map((branch) => DropdownMenuItem(
                          value: branch,
                          child: Text(branch),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBranch = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildDateField('Date From', _dateFrom, (date) {
            setState(() {
              _dateFrom = date;
            });
          }),
          const SizedBox(height: 16),
          _buildDateField('Date To', _dateTo, (date) {
            setState(() {
              _dateTo = date;
            });
          }),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tracking users location...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Track users last location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? date, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  date != null
                      ? '${date.day}/${date.month}/${date.year}'
                      : 'Select Date',
                  style: TextStyle(
                    color: date != null ? Colors.black : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataPage() {
    return Column(
      children: [
        if (_isLoading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          )
        else
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  '0',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No data available',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
