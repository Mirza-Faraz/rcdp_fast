import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../data/models/nearby_client_model.dart';
import '../manager/nearby_clients_cubit.dart';
import 'apply_filters_page.dart';
import 'nearby_clients_map_page.dart';
import 'nearby_clients_map_page.dart';

class ClientsNearbyPage extends StatelessWidget {
  const ClientsNearbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NearbyClientsCubit>(),
      child: const _ClientsNearbyView(),
    );
  }
}

class _ClientsNearbyView extends StatefulWidget {
  const _ClientsNearbyView();

  @override
  State<_ClientsNearbyView> createState() => _ClientsNearbyViewState();
}

class _ClientsNearbyViewState extends State<_ClientsNearbyView> {
  int _userId = 0;
  int _branchId = 0;
  
  final ScrollController _horizontalScrollController = ScrollController();
  
  // Define fixed widths for columns to ensure they are consistent and scrollable
  final Map<String, double> _columnSpecs = {
    'Sr#': 50,
    'Id': 100,
    'CNIC': 130,
    'Name': 150,
    'Address': 200,
    'Village': 150,
    'Distance': 100,
    'Loc': 60, // Location Icon
  };

  late double _totalTableWidth;

  @override
  void initState() {
    super.initState();
    _totalTableWidth = _columnSpecs.values.reduce((a, b) => a + b);
    _loadUserInfoAndFetch();
  }
  
  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfoAndFetch() async {
    final authRepo = sl<AuthRepository>();
    final userDescResult = await authRepo.getUserDescription();
    
    userDescResult.fold(
      (failure) => null,
      (userDesc) {
        if (userDesc != null) {
          setState(() {
            _userId = userDesc.userId;
            _branchId = 0; 
          });
          _fetchClients(isRefresh: true);
        }
      },
    );
  }

  void _fetchClients({bool isRefresh = false}) {
    if (_userId != 0) {
      context.read<NearbyClientsCubit>().fetchNearbyClients(
        userId: _userId,
        branchId: _branchId == 0 ? 43 : _branchId,
        isRefresh: isRefresh,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<NearbyClientsCubit, NearbyClientsState>(
          listener: (context, state) {
            if (state is NearbyClientsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            } else if (state is LocationPermissionRequired) {
               _showLocationError('Location permission is required.');
            } else if (state is LocationServiceDisabled) {
               _showLocationError('Please enable location services.');
            }
          },
          builder: (context, state) {
            List<NearbyClientModel> clients = [];
            bool hasReachedMax = false;
            if (state is NearbyClientsLoaded) {
              clients = state.clients;
              hasReachedMax = state.hasReachedMax;
            }
            
            return Column(
              children: [
                _buildHeader(clients.length, hasReachedMax),
                Expanded(
                  child: state is NearbyClientsLoading && clients.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : clients.isEmpty
                          ? _buildEmptyState()
                          : _buildScrollableTable(clients, hasReachedMax),
                ),
                _buildPaginationFooter(hasReachedMax),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildScrollableTable(List<NearbyClientModel> clients, bool hasReachedMax) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: _totalTableWidth > constraints.maxWidth 
                  ? _totalTableWidth 
                  : constraints.maxWidth,
              child: Column(
                children: [
                  _buildTableHeader(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: clients.length + (hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= clients.length) {
                           return const Padding(padding: EdgeInsets.all(8.0), child: Center(child: CircularProgressIndicator()));
                        }
                        return _buildTableRow(index, clients[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.primary,
      height: 48, // Fixed height for header
      child: Row(
        children: _columnSpecs.entries.map((entry) {
          return SizedBox(
            width: entry.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                entry.key,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableRow(int index, NearbyClientModel client) {
    return Container(
      height: 60, // Fixed height for rows to ensure consistency
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: _columnSpecs.entries.map((entry) {
          return SizedBox(
            width: entry.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: _buildCellContent(entry.key, client, index),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCellContent(String key, NearbyClientModel client, int index) {
    switch (key) {
      case 'Sr#':
        return Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold));
      case 'Id':
        return Text(client.memberId, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold));
      case 'CNIC':
        return Text(client.nicNew, style: const TextStyle(fontSize: 13));
      case 'Name':
        return Text(client.piName, maxLines: 2, overflow: TextOverflow.ellipsis);
      case 'Address':
        return Text(client.piPresentAddress ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12));
      case 'Village':
        return Text(client.piVillage, maxLines: 1, overflow: TextOverflow.ellipsis);
      case 'Distance':
        // Try to parse distance
        String dist = client.distance;
        try {
          double d = double.parse(dist);
          dist = d.toStringAsFixed(0);
        } catch (_) {}
        return Text(dist, style: const TextStyle(fontWeight: FontWeight.bold));
      case 'Loc':
        return IconButton(
          icon: const Icon(Icons.location_on, color: Colors.red, size: 20),
          onPressed: () {
             // Location simulates opening map, currently null/placeholder
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Location currently unavailable')),
             );
          },
        );
      default:
        return const Text('');
    }
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        action: SnackBarAction(label: 'Retry', onPressed: () => _fetchClients(isRefresh: true)),
      ),
    );
  }

  Widget _buildHeader(int count, bool hasReachedMax) {
    return Container(
      color: AppColors.primary,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Clients Nearby',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rows: $count',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
             Row(
                children: [
                    IconButton(
                        onPressed: () => _openFilters(),
                        icon: const Icon(Icons.filter_list, color: AppColors.primary, size: 28),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => const NearbyClientsMapPage())
                          );
                        },
                        icon: const Icon(Icons.location_on, color: AppColors.primary, size: 28),
                    ),
                ],
             )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.people_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Clients Nearby',
             style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('Record not Found'),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(bool hasReachedMax) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           if (!hasReachedMax)
           TextButton(
             onPressed: () {
                 _fetchClients();
             },
             child: const Text('Next >>', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
           ),
        ],
      ),
    );
  }

  void _openFilters() {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ApplyFiltersPage()));
  }
}
