class ApiEndpoints {

  static const String baseUrl = 'http://103.12.197.28:8000/api/';

  // Auth endpoints
  static const String login = '/Account/login';
  static const String logout = '/auth/logout';
  static const String changePassword = '/auth/change-password';
  static const String refreshToken = '/auth/refresh-token';

  // User endpoints
  static const String getUserProfile = '/user/profile';
  static const String updateProfile = '/user/profile';

  // Add more endpoints as needed
  // static const String getClients = '/clients';
  // static const String getDisbursements = '/disbursements';
}
