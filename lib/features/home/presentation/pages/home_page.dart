import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'settings_page.dart';
import 'data_detail_page.dart';
import 'menu_detail_page.dart';
import 'approvals_page.dart';
import 'follow_up_clients_page.dart';
import 'recovery_form_page.dart';
import 'overdue_clients_page.dart';
import 'clients_nearby_page.dart';
import 'reports_page.dart';
import 'loan_tracking_list_page.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../data/models/dashboard_model.dart';
import 'disbursement_page.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final String userRole;

  const HomePage({super.key, required this.userName, required this.userRole});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String _selectedDataItem = 'Active Areas'; // Default selection
  String _selectedAmount = '0';
  List<DashboardItem> _dashboardItems = [];
  int _userId = 0;
  bool _isAmountLoading = false;

  @override
  @override
  void initState() {
    super.initState();
    _errorMessage = '';
    _loadInitialData();
  }
  
  String _errorMessage = '';

  Future<void> _loadInitialData() async {
    await _getUserDetails();
    await _fetchDashboardList();
  }

  Future<void> _getUserDetails() async {
    final result = await sl<AuthRepository>().getUserDescription();
    result.fold(
      (failure) => debugPrint('Error getting user details: ${failure.message}'),
      (userDescription) {
        if (userDescription != null) {
          setState(() {
            _userId = userDescription.userId;
          });
        }
      },
    );
  }

  Future<void> _fetchDashboardList() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final apiClient = sl<ApiClient>();
      final response = await apiClient.get(ApiEndpoints.dashboard);
      
      if (response.statusCode == 200) {
        final dashboardResponse = DashboardResponse.fromJson(response.data);
        if (mounted) {
          setState(() {
            _dashboardItems = dashboardResponse.data;
            _isLoading = false;
            
            // If items are loaded, select the first one and fetch its amount
            if (_dashboardItems.isNotEmpty) {
              final firstItem = _dashboardItems.first;
              _selectedDataItem = firstItem.description;
              _fetchAmount(firstItem.description);
            }
          });
        }
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _fetchAmount(String itemName) async {
    if (_userId == 0) return; // Wait for user ID
    
    setState(() {
      _isAmountLoading = true;
      _selectedDataItem = itemName;
    });

    try {
      final apiClient = sl<ApiClient>();
      
      // Determine date range (default to current month or similar, taking simplest approach for now)
      final now = DateTime.now();
      final formatter = DateFormat('yyyy-MM-dd');
      // Assuming today for both or start of month to today based on typical dashboard needs.
      // User prompt: "DateFrom={DateFrom}&DateTo={DateTo}"
      // I'll default to "start of month" to "today" as a reasonable default, or just today if unsure.
      // Let's use today for both for now to minimize data volume, or maybe start of month?
      // Given "Active Clients", "Overdue", etc., these are point-in-time often, but "Disbursement" is over time.
      // I will use current date for both to be safe, or perhaps start of month.
      // Let's try 1st of month to today.
      final dateFrom = formatter.format(DateTime(now.year, now.month, 1));
      final dateTo = formatter.format(now);

      final response = await apiClient.get(
        ApiEndpoints.dashboardAmount,
        queryParameters: {
          'User_id': _userId,
          'DateFrom': dateFrom,
          'DateTo': dateTo,
          'Name': itemName,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        String amount = '0';
        if (data['data'] != null && (data['data'] as List).isNotEmpty) {
           final firstItem = (data['data'] as List).first;
           amount = firstItem['Total']?.toString() ?? firstItem['Amount']?.toString() ?? '0';
        } else if (data['total'] != null) {
           amount = data['total'].toString();
        }
        
        // Format the amount to remove .0000 onwards
        amount = _formatAmount(amount);
        
        if (mounted) {
          setState(() {
            _selectedAmount = amount;
            _isAmountLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedAmount = 'Error';
          _isAmountLoading = false;
        });
      }
    }
  }
  String _formatAmount(String amount) {
    if (amount == 'Error' || amount == '0') return amount;
    
    try {
      // Try parsing as double to handle cases like "0.0000"
      double val = double.parse(amount);
      // If it's effectively an integer, return as int string
      if (val == val.toInt()) {
        return val.toInt().toString();
      }
      // Otherwise, if it has decimals, truncate or keep as is? 
      // User said "should not show the .000 onwards data"
      // This usually implies they want integers on dashboard.
      return val.toInt().toString();
    } catch (e) {
      // Fallback: if not a number, split by dot if exists
      if (amount.contains('.')) {
        return amount.split('.').first;
      }
      return amount;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildMenuGrid(),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    else
                      _buildDataHeader(),
                    const SizedBox(height: 16),
                    Expanded(child: _buildInfoCards()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(widget.userRole, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    final menuItems = [
      _MenuItem(icon: '📊', label: 'CLIENT DISBURSEMENT', subtitle: '', route: 'client_disbursement'),
      _MenuItem(icon: '📄', label: 'APPROVALS', subtitle: '', route: 'approvals'),
      _MenuItem(icon: '📋', label: 'FOLLOW UP\nCLIENTS', subtitle: '', route: 'follow_up_clients'),
      _MenuItem(icon: '🛡️', label: 'RECOVERY\nFORM', subtitle: '', route: 'recovery_form'),
      _MenuItem(icon: '⏰', label: 'OVERDUE\nCLIENTS', subtitle: '', route: 'overdue_clients'),
      _MenuItem(icon: '👥', label: 'CLIENTS\nNEARBY', subtitle: '', route: 'clients_nearby'),
      _MenuItem(icon: '📈', label: 'REPORTS', subtitle: '', route: 'reports'),
      _MenuItem(icon: '📝', label: 'LOAN\nTRACKING LIST', subtitle: '', route: 'loan_tracking_list'),
    ];

    // Fixed icon size for consistency across all items (works for both iOS and Android)
    final iconSize = 60.0;
    
    // Responsive font size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 380 ? 9.0 : (screenWidth < 420 ? 10.0 : 10.0);
    
    // Calculate spacing for 4 columns
    final crossAxisSpacing = 12.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85, // Optimized for 4-column layout with icon and text
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: crossAxisSpacing,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return _buildMenuItem(menuItems[index], iconSize: iconSize, fontSize: fontSize);
        },
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item, {required double iconSize, required double fontSize}) {
    return GestureDetector(
      onTap: () {
        // Navigate to specific pages based on route
        switch (item.route) {
          case 'client_disbursement':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const DisbursementPage()));
            break;
          case 'approvals':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ApprovalsPage()));
            break;
          case 'follow_up_clients':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FollowUpClientsPage()));
            break;
          case 'recovery_form':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RecoveryFormPage()));
            break;
          case 'overdue_clients':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OverdueClientsPage()));
            break;
          case 'clients_nearby':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientsNearbyPage()));
            break;
          case 'reports':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsPage()));
            break;
          case 'loan_tracking_list':
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoanTrackingListPage()));
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MenuDetailPage(title: item.label.replaceAll('\n', ' '), icon: _getIconForRoute(item.route)),
              ),
            );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item.icon,
                style: const TextStyle(fontSize: 30), // Fixed emoji size for consistency
              ),
            ),
          ),
          SizedBox(height: iconSize * 0.15), // Responsive spacing
          Flexible(
            child: Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          if (item.subtitle.isNotEmpty)
            Text(
              item.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize * 0.8,
                height: 1.2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataHeader() {
    return Column(
      children: [
        Text(
          _selectedDataItem,
          style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_isAmountLoading)
          const SizedBox(
            height: 48, 
            width: 48, 
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else
          Text(
            _selectedAmount,
            style: const TextStyle(color: AppColors.primary, fontSize: 48, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  IconData _getIconForRoute(String route) {
    switch (route) {
      case 'client_disbursement':
        return Icons.account_balance_wallet;
      case 'approvals':
        return Icons.check_circle;
      case 'follow_up_clients':
        return Icons.follow_the_signs;
      case 'recovery_form':
        return Icons.receipt_long;
      case 'overdue_clients':
        return Icons.access_time;
      case 'clients_nearby':
        return Icons.location_on;
      case 'reports':
        return Icons.assessment;
      case 'loan_tracking_list':
        return Icons.list_alt;
      default:
        return Icons.dashboard;
    }
  }

  Widget _buildInfoCards() {
    if (_dashboardItems.isEmpty) {
      return Center(
        child: _errorMessage.isNotEmpty 
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchDashboardList,
                    child: const Text('Retry'),
                  )
                ],
              )
            : const Text('No data available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _dashboardItems.length,
      itemBuilder: (context, index) {
        final item = _dashboardItems[index];
        final iconData = _getIconForDataDescription(item.description);
        
        return GestureDetector(
          onTap: () {
            _fetchAmount(item.description);
            // Optional: Navigate if needed, but current requirement is to show amount at top
            // The original code navigated to DataDetailPage. 
            // The prompt says: "when user clicks ... it will show its number or its name at top of it"
            // It does NOT say to navigate. It implies updating the header.
            // However, the original code had navigation. I will keep navigation temporarily DISABLED or remove it
            // if the requirement implies single page. 
            // "You will amount for the item you clicked, you just need to send the name of that item in this API"
            // "when user clicks on that scrollable dashboard on the home screen for the any of the page it will show its number or its name at top of it"
            // This strongly implies staying on the same page.
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _selectedDataItem == item.description ? AppColors.primary.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: _selectedDataItem == item.description ? Border.all(color: AppColors.primary, width: 1) : null,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(iconData, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.description,
                    style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                if (_selectedDataItem == item.description && !_isAmountLoading)
                 Text(
                   _selectedAmount, // Show amount inline too? Maybe not, stick to header as requested.
                   style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold), 
                 ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForDataDescription(String description) {
    if (description.contains('Area')) return Icons.location_on;
    if (description.contains('Branch')) return Icons.business;
    if (description.contains('Client')) return Icons.people;
    if (description.contains('CO')) return Icons.person;
    if (description.contains('Village')) return Icons.home;
    if (description.contains('Amount')) return Icons.attach_money;
    if (description.contains('Disbursed')) return Icons.attach_money; // Fallback
    if (description.contains('Death')) return Icons.person_off;
    if (description.contains('Center')) return Icons.store;
    if (description.contains('Target')) return Icons.flag;
    if (description.contains('File')) return Icons.folder;
    if (description.contains('Loan')) return Icons.money;
    if (description.contains('Overdue')) return Icons.access_time;
    if (description.contains('PAR')) return Icons.pie_chart;
    if (description.contains('Recovery')) return Icons.check_circle;
    
    return Icons.insert_chart; // Default
  }
}

class _MenuItem {
  final String icon;
  final String label;
  final String subtitle;
  final String route;

  _MenuItem({required this.icon, required this.label, this.subtitle = '', required this.route});
}

class _InfoCard {
  final IconData icon;
  final String title;
  final Color color;
  final String dataType;

  _InfoCard({required this.icon, required this.title, required this.color, required this.dataType});
}
