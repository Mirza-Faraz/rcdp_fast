import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'settings_page.dart';
import 'data_detail_page.dart';
import 'menu_detail_page.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final String userRole;

  const HomePage({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String _selectedDataItem = 'Active Areas';

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() {
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    else
                      _buildDataHeader(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildInfoCards(),
                    ),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.userRole,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    final menuItems = [
      _MenuItem(
        icon: '📊',
        label: 'CLIENT DISB\nURSEMENT',
        subtitle: 'کلائنٹ کی\nتقسیم',
        route: 'client_disbursement',
      ),
      _MenuItem(
        icon: '📄',
        label: 'APPROVALS',
        subtitle: '',
        route: 'approvals',
      ),
      _MenuItem(
        icon: '📋',
        label: 'FOLLOW UP\nCLIENTS',
        subtitle: '',
        route: 'follow_up_clients',
      ),
      _MenuItem(
        icon: '🛡️',
        label: 'RECOVERY\nFORM',
        subtitle: '',
        route: 'recovery_form',
      ),
      _MenuItem(
        icon: '⏰',
        label: 'OVERDUE\nCLIENTS',
        subtitle: '',
        route: 'overdue_clients',
      ),
      _MenuItem(
        icon: '👥',
        label: 'CLIENTS\nNEARBY',
        subtitle: '',
        route: 'clients_nearby',
      ),
      _MenuItem(
        icon: '📈',
        label: 'REPORTS',
        subtitle: '',
        route: 'reports',
      ),
      _MenuItem(
        icon: '📝',
        label: 'LOAN\nTREARING LIST',
        subtitle: '',
        route: 'loan_trearing_list',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return _buildMenuItem(menuItems[index]);
        },
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return GestureDetector(
      onTap: () {
        // Special handling for Clients Nearby (tracking page)
        if (item.route == 'clients_nearby') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DataDetailPage(
                title: item.label.replaceAll('\n', ' '),
                dataType: item.route,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MenuDetailPage(
                title: item.label.replaceAll('\n', ' '),
                icon: _getIconForRoute(item.route),
              ),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item.icon,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          if (item.subtitle.isNotEmpty)
            Text(
              item.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
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
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '0',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
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
      case 'loan_trearing_list':
        return Icons.list_alt;
      default:
        return Icons.dashboard;
    }
  }

  Widget _buildInfoCards() {
    final cards = [
      _InfoCard(
        icon: Icons.location_on,
        title: 'Active Areas',
        color: AppColors.primary,
        dataType: 'active_areas',
      ),
      _InfoCard(
        icon: Icons.business,
        title: 'Active Branches',
        color: AppColors.primary,
        dataType: 'active_branches',
      ),
      _InfoCard(
        icon: Icons.people,
        title: 'Active Clients',
        color: AppColors.primary,
        dataType: 'active_clients',
      ),
      _InfoCard(
        icon: Icons.person,
        title: 'Active CO',
        color: AppColors.primary,
        dataType: 'active_co',
      ),
      _InfoCard(
        icon: Icons.home,
        title: 'Active Villages',
        color: AppColors.primary,
        dataType: 'active_villages',
      ),
      _InfoCard(
        icon: Icons.attach_money,
        title: 'Amount Disbursed',
        color: AppColors.primary,
        dataType: 'amount_disbursed',
      ),
      _InfoCard(
        icon: Icons.person_off,
        title: 'Death Clients',
        color: AppColors.primary,
        dataType: 'death_clients',
      ),
      _InfoCard(
        icon: Icons.store,
        title: 'Disburs Centers',
        color: AppColors.primary,
        dataType: 'disburs_centers',
      ),
      _InfoCard(
        icon: Icons.trending_up,
        title: 'Disbursement Achievement',
        color: AppColors.primary,
        dataType: 'disbursement_achievement',
      ),
      _InfoCard(
        icon: Icons.flag,
        title: 'Disbursement Target',
        color: AppColors.primary,
        dataType: 'disbursement_target',
      ),
      _InfoCard(
        icon: Icons.folder_open,
        title: 'File in Process',
        color: AppColors.primary,
        dataType: 'file_in_process',
      ),
      _InfoCard(
        icon: Icons.folder,
        title: 'File Submitted',
        color: AppColors.primary,
        dataType: 'file_submitted',
      ),
      _InfoCard(
        icon: Icons.cancel,
        title: 'No Loan Disbursed',
        color: AppColors.primary,
        dataType: 'no_loan_disbursed',
      ),
      _InfoCard(
        icon: Icons.access_time,
        title: 'Overdue Clients',
        color: AppColors.primary,
        dataType: 'overdue_clients',
      ),
      _InfoCard(
        icon: Icons.pie_chart,
        title: 'PAR',
        color: AppColors.primary,
        dataType: 'par',
      ),
      _InfoCard(
        icon: Icons.check_circle,
        title: 'Recovery Achievement',
        color: AppColors.primary,
        dataType: 'recovery_achievement',
      ),
      _InfoCard(
        icon: Icons.calendar_today,
        title: 'Recovery Target Till Date',
        color: AppColors.primary,
        dataType: 'recovery_target_till_date',
      ),
      _InfoCard(
        icon: Icons.calendar_month,
        title: 'Recovery Till Date',
        color: AppColors.primary,
        dataType: 'recovery_till_date',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDataItem = card.title;
              _isLoading = true;
            });
            _simulateLoading();
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DataDetailPage(
                  title: card.title,
                  dataType: card.dataType,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: card.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    card.icon,
                    color: card.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    card.title,
                    style: TextStyle(
                      color: card.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final String icon;
  final String label;
  final String subtitle;
  final String route;

  _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle = '',
    required this.route,
  });
}

class _InfoCard {
  final IconData icon;
  final String title;
  final Color color;
  final String dataType;

  _InfoCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.dataType,
  });
}
