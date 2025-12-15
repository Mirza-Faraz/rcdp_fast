class ApiEndpoints {
  static const String baseUrl = 'http://103.12.197.28:8000/api/';

  // Auth endpoints
  static const String login = '/Account/login';
  static const String logout = '/auth/logout';
  static const String changePassword = '/auth/change-password';
  static const String refreshToken = '/auth/refresh-token';

  // User endpoints
  static const String getUserProfile = '/UserDefinition/Profile';
  static const String updateProfile = '/user/profile';

  // Product endpoints
  static const String getProductDropDown = '/Product/GetProductDropDown';

  // Branch endpoints
  static const String getBranchDropDown = '/Branch/BranchDropSown';

  // Case/Approvals endpoints
  static const String getCaseList = '/SubmitCase/CaseList';
  static const String getOverdueClients = '/SubmitCase/OverDueClients';
  static const String getFollowUpClients = '/SubmitCase/OverDueClients'; // Reusing Overdue endpoint as per user request

  // Add more endpoints as needed
  // static const String getClients = '/clients';
  // static const String getDisbursements = '/disbursements';
}
