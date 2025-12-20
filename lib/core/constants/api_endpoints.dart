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

  // Dashboard endpoints
  static const String dashboard = '/Dashboard/DashBoard';
  static const String dashboardAmount = '/Dashboard/DashBoardAmount';

  // User Rights
  static const String getUserRights = '/UserRights/GetUserRights';

  // Branch Info
  static const String getBranchesByUserId = '/ClientInfo/GetBranchesByUserId';
  static const String getCenterNumber = '/SubmitCase/GetCenterNumber';
  static const String getProductByBranch = '/SubmitCase/GetProductByBranch';
  static const String getCoByBranch = '/SubmitCase/GetCoByBranch';
  static const String clientSearch = '/ClientInfo/ClientSearch';

  // Product endpoints
  static const String getProductDropDown = '/Product/GetProductDropDown';

  // Branch endpoints
  static const String getBranchDropDown = '/Branch/BranchDropSown';

  // Case/Approvals endpoints
  static const String getCaseList = '/SubmitCase/CaseList';
  static const String getOverdueClients = '/SubmitCase/OverDueClients';
  static const String getFollowUpClients = '/SubmitCase/OverDueClients'; // Reusing Overdue endpoint as per user request
  static const String nearbyClient = '/SubmitCase/NearByClients';

  // Report endpoints
  static const String clientLedgerReport = 'Report/ClientLedgerReport';
  static const String summaryReport = 'Report/SummaryReport';
  static const String ldfReport = 'Report/Report';

  // Add more endpoints as needed
  // static const String getClients = '/clients';
  // static const String getDisbursements = '/disbursements';
}
