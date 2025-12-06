import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';

class HouseholdAssetsPage extends StatefulWidget {
  final String clientName;
  final String clientId;
  final String? cnic;
  final String? memberId;

  const HouseholdAssetsPage({super.key, required this.clientName, required this.clientId, this.cnic, this.memberId});

  @override
  State<HouseholdAssetsPage> createState() => _HouseholdAssetsPageState();
}

class _HouseholdAssetsPageState extends State<HouseholdAssetsPage> {
  // Household Assets And Livestock controllers (House Value, Plot Value, Agri Land)
  final TextEditingController _houseValueNumberController = TextEditingController();
  final TextEditingController _houseValueAmountController = TextEditingController();
  final TextEditingController _plotValueNumberController = TextEditingController();
  final TextEditingController _plotValueAmountController = TextEditingController();
  final TextEditingController _agriLandNumberController = TextEditingController();
  final TextEditingController _agriLandAmountController = TextEditingController();

  // LiveStock controllers
  final Map<String, TextEditingController> _livestockNumberControllers = {};
  final Map<String, TextEditingController> _livestockAmountControllers = {};

  // Household Assets controllers
  final Map<String, TextEditingController> _assetsNumberControllers = {};
  final Map<String, TextEditingController> _assetsAmountControllers = {};

  // CashFlow Analysis controllers
  final TextEditingController _businessRevenueAmountController = TextEditingController();
  final Map<String, TextEditingController> _businessExpenseAmountControllers = {};
  final Map<String, String?> _businessExpenseFrequency = {};

  // Other Income controllers
  final Map<String, TextEditingController> _otherIncomeAmountControllers = {};
  final Map<String, String?> _otherIncomeFrequency = {};

  // Other Expenses controllers
  final Map<String, TextEditingController> _otherExpenseAmountControllers = {};
  final Map<String, String?> _otherExpenseFrequency = {};

  final List<String> _livestockItems = ['Cow', 'Buffalo', 'Ox', 'Sheep', 'Goat', 'Chicken', 'Others'];
  final List<String> _householdAssetsItems = [
    'Bicycle',
    'Scooter',
    'Motorcycle',
    'Auto Rickshaw',
    'Tractor',
    'Sewing Machine',
    'Gas',
    'CD/DVD player',
    'Music System',
    'Cooler',
    'Refrigerator',
    'Washing Machine',
    'TV',
    'Water Purifier',
    'Mobile Phone',
    'Furniture',
    'Others',
  ];

  final List<String> _businessExpenseItems = ['Raw Material', 'Utilities', 'Rent', 'Employee Salaries', 'Transportation', 'Maintenance', 'Others'];
  final List<String> _otherIncomeItems = ['Other Household Income', 'Salaries', 'Remittances', 'Agri/Livestock', 'Other'];
  final List<String> _otherExpenseItems = [
    'Food',
    'Rent',
    'Electricity',
    'Children Education',
    'Clothing',
    'Medicine and Hospital',
    'Tobacco/Alcohol',
    'Celebrations',
    'Debt Repayment',
    'Other',
  ];

  final List<String> _frequencyOptions = ['Monthly', 'Weekly', 'Annually'];

  @override
  void initState() {
    super.initState();
    // Initialize livestock controllers
    for (var item in _livestockItems) {
      _livestockNumberControllers[item] = TextEditingController();
      _livestockAmountControllers[item] = TextEditingController();
      _livestockNumberControllers[item]!.addListener(_updateTotals);
      _livestockAmountControllers[item]!.addListener(_updateTotals);
    }
    // Initialize household assets controllers
    for (var item in _householdAssetsItems) {
      _assetsNumberControllers[item] = TextEditingController();
      _assetsAmountControllers[item] = TextEditingController();
      _assetsNumberControllers[item]!.addListener(_updateTotals);
      _assetsAmountControllers[item]!.addListener(_updateTotals);
    }
    // Initialize business expense controllers
    for (var item in _businessExpenseItems) {
      _businessExpenseAmountControllers[item] = TextEditingController();
      _businessExpenseFrequency[item] = 'Monthly';
      _businessExpenseAmountControllers[item]!.addListener(_updateTotals);
    }
    // Initialize other income controllers
    for (var item in _otherIncomeItems) {
      _otherIncomeAmountControllers[item] = TextEditingController();
      _otherIncomeFrequency[item] = 'Monthly';
      _otherIncomeAmountControllers[item]!.addListener(_updateTotals);
    }
    // Initialize other expenses controllers
    for (var item in _otherExpenseItems) {
      _otherExpenseAmountControllers[item] = TextEditingController();
      _otherExpenseFrequency[item] = 'Monthly';
      _otherExpenseAmountControllers[item]!.addListener(_updateTotals);
    }
    // Initialize main asset controllers
    _houseValueNumberController.addListener(_updateTotals);
    _houseValueAmountController.addListener(_updateTotals);
    _plotValueNumberController.addListener(_updateTotals);
    _plotValueAmountController.addListener(_updateTotals);
    _agriLandNumberController.addListener(_updateTotals);
    _agriLandAmountController.addListener(_updateTotals);
    _businessRevenueAmountController.addListener(_updateTotals);
  }

  @override
  void dispose() {
    _houseValueNumberController.dispose();
    _houseValueAmountController.dispose();
    _plotValueNumberController.dispose();
    _plotValueAmountController.dispose();
    _agriLandNumberController.dispose();
    _agriLandAmountController.dispose();
    _businessRevenueAmountController.dispose();
    for (var controller in _livestockNumberControllers.values) controller.dispose();
    for (var controller in _livestockAmountControllers.values) controller.dispose();
    for (var controller in _assetsNumberControllers.values) controller.dispose();
    for (var controller in _assetsAmountControllers.values) controller.dispose();
    for (var controller in _businessExpenseAmountControllers.values) controller.dispose();
    for (var controller in _otherIncomeAmountControllers.values) controller.dispose();
    for (var controller in _otherExpenseAmountControllers.values) controller.dispose();
    super.dispose();
  }

  void _updateTotals() {
    setState(() {});
  }

  int _parseValue(String text) => int.tryParse(text.replaceAll(',', '')) ?? 0;

  int _getHouseholdAssetsAndLivestockTotalNumber() {
    return _parseValue(_houseValueNumberController.text) +
        _parseValue(_plotValueNumberController.text) +
        _parseValue(_agriLandNumberController.text) +
        _livestockNumberControllers.values.fold(0, (sum, controller) => sum + _parseValue(controller.text));
  }

  int _getHouseholdAssetsAndLivestockTotalAmount() {
    return _parseValue(_houseValueAmountController.text) +
        _parseValue(_plotValueAmountController.text) +
        _parseValue(_agriLandAmountController.text) +
        _livestockAmountControllers.values.fold(0, (sum, controller) => sum + _parseValue(controller.text));
  }

  int _getHouseholdAssetsTotalNumber() {
    return _assetsNumberControllers.values.fold(0, (sum, controller) => sum + _parseValue(controller.text));
  }

  int _getHouseholdAssetsTotalAmount() {
    return _assetsAmountControllers.values.fold(0, (sum, controller) => sum + _parseValue(controller.text));
  }

  int _getBusinessExpenseTotal() {
    return _businessExpenseAmountControllers.values.fold(0, (sum, controller) => sum + _parseValue(controller.text));
  }

  int _getOtherIncomeTotal() {
    return _otherIncomeAmountControllers.values.fold(0, (sum, controller) => sum + _parseValue(controller.text));
  }

  int _getOtherExpenseTotal() {
    return _otherExpenseAmountControllers.values.fold(0, (sum, controller) => sum + _parseValue(controller.text));
  }

  int _getNetBusinessIncome() {
    return _parseValue(_businessRevenueAmountController.text) - _getBusinessExpenseTotal();
  }

  int _getTotalMonthlyValue() {
    int businessIncome = _parseValue(_businessRevenueAmountController.text);
    int businessExpense = _getBusinessExpenseTotal();
    int otherIncome = _getOtherIncomeTotal();
    int otherExpense = _getOtherExpenseTotal();
    return businessIncome - businessExpense + otherIncome - otherExpense;
  }

  int _getTotalAnnuallyValue() {
    return _getTotalMonthlyValue() * 12;
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildUserInfoCard(),
                      const SizedBox(height: 24),
                      _buildHouseholdAssetsAndLivestockSection(),
                      const SizedBox(height: 24),
                      _buildHouseholdAssetsSection(),
                      const SizedBox(height: 24),
                      _buildCashFlowAnalysisSection(),
                      const SizedBox(height: 24),
                      _buildOtherIncomeSection(),
                      const SizedBox(height: 24),
                      _buildOtherExpensesSection(),
                      const SizedBox(height: 24),
                      _buildFinalTotals(),
                      const SizedBox(height: 32),
                      _buildNextButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Household Assets & Cashflow',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Saima Test | Credit Officer | Multan 2',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                icon: Icon(Icons.home, color: AppColors.primary),
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Name', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      widget.clientName,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('CNIC', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      widget.cnic ?? widget.clientId,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('ID', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      widget.memberId ?? widget.clientId,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Household Assets & Cashflow',
            style: TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseholdAssetsAndLivestockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300, thickness: 1),
        const SizedBox(height: 8),
        const Text(
          'Household Assets And Livestock',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Particular',
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Number',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Amount',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAssetRow('House Value', _houseValueNumberController, _houseValueAmountController),
        _buildAssetRow('Plot Value', _plotValueNumberController, _plotValueAmountController),
        _buildAssetRow('Agri Land', _agriLandNumberController, _agriLandAmountController),
        const SizedBox(height: 16),
        const Text(
          'LiveStock',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 8),
        ..._livestockItems.map((item) => _buildAssetRow(item, _livestockNumberControllers[item]!, _livestockAmountControllers[item]!)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total Value',
                  style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatNumber(_getHouseholdAssetsAndLivestockTotalNumber()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatNumber(_getHouseholdAssetsAndLivestockTotalAmount()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHouseholdAssetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300, thickness: 1),
        const SizedBox(height: 8),
        const Text(
          'Household Assets',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Particular',
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Number',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Amount',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._householdAssetsItems.map((item) => _buildAssetRow(item, _assetsNumberControllers[item]!, _assetsAmountControllers[item]!)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total Value',
                  style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatNumber(_getHouseholdAssetsTotalNumber()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatNumber(_getHouseholdAssetsTotalAmount()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCashFlowAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300, thickness: 1),
        const SizedBox(height: 8),
        const Text(
          'CashFlow Analysis',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Particular',
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Frequency',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Amount',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildCashFlowRow('Business Revenue/Sales', _businessRevenueAmountController, null),
        const SizedBox(height: 8),
        const Text(
          'Business Expenses',
          style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ..._businessExpenseItems.map((item) => _buildCashFlowRow(item, _businessExpenseAmountControllers[item]!, item)),
        const SizedBox(height: 8),
        _buildCashFlowRow('Total Business Expense', null, null, isTotal: true, totalValue: _getBusinessExpenseTotal()),
        const SizedBox(height: 8),
        _buildCashFlowRow('Net Business Income', null, null, isTotal: true, totalValue: _getNetBusinessIncome()),
      ],
    );
  }

  Widget _buildOtherIncomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300, thickness: 1),
        const SizedBox(height: 8),
        const Text(
          'Other Income',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Particular',
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Frequency',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Amount',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._otherIncomeItems.map((item) => _buildCashFlowRow(item, _otherIncomeAmountControllers[item]!, item)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total Value',
                  style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Monthly',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatNumber(_getOtherIncomeTotal()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtherExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300, thickness: 1),
        const SizedBox(height: 8),
        const Text(
          'Other Expenses',
          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Particular',
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Frequency',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                'Amount',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._otherExpenseItems.map((item) => _buildCashFlowRow(item, _otherExpenseAmountControllers[item]!, item)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total Other Expenses',
                  style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Monthly',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatNumber(_getOtherExpenseTotal()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinalTotals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total Value',
                  style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Monthly',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatNumber(_getTotalMonthlyValue()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Annually',
                  style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: const SizedBox()),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatNumber(_getTotalAnnuallyValue()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetRow(String label, TextEditingController numberController, TextEditingController amountController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, ThousandsSeparatorInputFormatter()],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, ThousandsSeparatorInputFormatter()],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowRow(String label, TextEditingController? amountController, String? frequencyKey, {bool isTotal = false, int? totalValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: isTotal ? AppColors.primary : Colors.black87, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isTotal
                  ? Text(
                      'Monthly',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                    )
                  : frequencyKey != null
                  ? GestureDetector(
                      onTap: () => _showFrequencyDropdown(context, frequencyKey),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_getFrequencyForItem(frequencyKey), style: const TextStyle(fontSize: 14, color: Colors.black87)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black87),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isTotal
                  ? Text(
                      totalValue != null ? _formatNumber(totalValue) : '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                    )
                  : TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, ThousandsSeparatorInputFormatter()],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFrequencyDropdown(BuildContext context, String key) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: ListView.builder(
          itemCount: _frequencyOptions.length,
          itemBuilder: (context, index) {
            final option = _frequencyOptions[index];
            return ListTile(
              title: Text(option),
              onTap: () {
                setState(() {
                  if (_businessExpenseFrequency.containsKey(key)) {
                    _businessExpenseFrequency[key] = option;
                  } else if (_otherIncomeFrequency.containsKey(key)) {
                    _otherIncomeFrequency[key] = option;
                  } else if (_otherExpenseFrequency.containsKey(key)) {
                    _otherExpenseFrequency[key] = option;
                  }
                });
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  String _getFrequencyForItem(String key) {
    if (_businessExpenseFrequency.containsKey(key)) return _businessExpenseFrequency[key] ?? 'Monthly';
    if (_otherIncomeFrequency.containsKey(key)) return _otherIncomeFrequency[key] ?? 'Monthly';
    if (_otherExpenseFrequency.containsKey(key)) return _otherExpenseFrequency[key] ?? 'Monthly';
    return 'Monthly';
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Household Assets & Cashflow information saved'), backgroundColor: AppColors.primary));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && (digitsOnly.length - i) % 3 == 0) formatted += ',';
      formatted += digitsOnly[i];
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
