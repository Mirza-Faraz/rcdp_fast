class DashboardItem {
  final String description;
  final String? total;

  DashboardItem({required this.description, this.total});

  factory DashboardItem.fromJson(Map<String, dynamic> json) {
    return DashboardItem(
      description: json['Description'] ?? '',
      total: json['Total']?.toString(), // Handle null or number
    );
  }
}

class DashboardResponse {
  final String message;
  final List<DashboardItem> data;
  final String status;

  DashboardResponse({
    required this.message,
    required this.data,
    required this.status,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((e) => DashboardItem.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? 'False',
    );
  }
}
