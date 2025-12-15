# How to Use Saved User Data in Your App

## 📦 What Gets Saved After Login

When a user successfully logs in, the following data is automatically saved:

1. **Token** - Authentication token (`Basic QWxpIEFyaWY6Z2tWdHRZbHJTTUFZNXpKL21kYlQ0dz09`)
2. **User Description** - Complete user information:
   - `Designation` - "Credit Officer"
   - `UserBranch` - "Branch"
   - `UserName` - "ali arif "
   - `UserId` - 91248
   - `DesignationId` - 1
   - `Group_ID` - 76
   - `BusinessInfoReq` - 1
   - `LoadUtByProduct` - 0
3. **Username** - For quick access
4. **Login Status** - Boolean flag
5. **Complete Login Response** - Entire response for easy retrieval

---

## 🔍 How to Access Saved Data

### Method 1: Through Repository (Recommended for Clean Architecture)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart' as di;
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/data/models/login_response_model.dart';

// In your widget or BLoC
Future<void> getSavedUserData() async {
  final repository = di.sl<AuthRepository>();
  
  // Get complete login response
  final result = await repository.getLoginResponse();
  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (loginResponse) {
      if (loginResponse != null) {
        print('User Name: ${loginResponse.userDescription.userName}');
        print('Designation: ${loginResponse.userDescription.designation}');
        print('User ID: ${loginResponse.userDescription.userId}');
        print('Token: ${loginResponse.token}');
      }
    },
  );
  
  // Or get specific data
  final userDescResult = await repository.getUserDescription();
  userDescResult.fold(
    (failure) => print('Error: ${failure.message}'),
    (userDesc) {
      if (userDesc != null) {
        print('User Name: ${userDesc.userName}');
        print('Branch: ${userDesc.userBranch}');
        print('Group ID: ${userDesc.groupId}');
      }
    },
  );
  
  // Get token
  final tokenResult = await repository.getToken();
  tokenResult.fold(
    (failure) => print('Error: ${failure.message}'),
    (token) {
      if (token != null) {
        print('Token: $token');
        // Use token for API calls
      }
    },
  );
}
```

### Method 2: Create a Use Case (Better for Business Logic)

First, create a use case file:

**File:** `lib/features/auth/domain/usecases/get_login_response_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/login_response_model.dart';

class GetLoginResponseUseCase {
  final AuthRepository repository;

  GetLoginResponseUseCase(this.repository);

  Future<Either<Failure, LoginResponseModel?>> call() async {
    return await repository.getLoginResponse();
  }
}
```

Then register it in `injection_container.dart`:

```dart
sl.registerLazySingleton(() => GetLoginResponseUseCase(sl()));
```

Use it in your BLoC or widget:

```dart
final getLoginResponseUseCase = di.sl<GetLoginResponseUseCase>();
final result = await getLoginResponseUseCase();
result.fold(
  (failure) => print('Error'),
  (loginResponse) => print('User: ${loginResponse?.userDescription.userName}'),
);
```

### Method 3: Direct Access (Quick Access, Less Recommended)

```dart
import '../../../../injection_container.dart' as di;
import '../../../auth/data/datasources/auth_local_data_source.dart';

Future<void> quickAccess() async {
  final localDataSource = di.sl<AuthLocalDataSource>();
  
  final token = await localDataSource.getToken();
  final userDesc = await localDataSource.getUserDescription();
  
  print('Token: $token');
  print('User: ${userDesc?.userName}');
}
```

---

## 💡 Practical Examples

### Example 1: Display User Info in Home Page

```dart
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String userRole = '';
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final repository = di.sl<AuthRepository>();
    
    final result = await repository.getLoginResponse();
    result.fold(
      (failure) {
        // Handle error
      },
      (loginResponse) {
        if (loginResponse != null) {
          setState(() {
            userName = loginResponse.userDescription.userName;
            userRole = loginResponse.userDescription.designation;
            userId = loginResponse.userDescription.userId;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $userName'),
        subtitle: Text(userRole),
      ),
      // ... rest of your UI
    );
  }
}
```

### Example 2: Use Token in API Calls

```dart
Future<void> makeAuthenticatedApiCall() async {
  final repository = di.sl<AuthRepository>();
  
  final tokenResult = await repository.getToken();
  tokenResult.fold(
    (failure) => print('No token available'),
    (token) async {
      if (token != null) {
        // Use token in your API client
        final apiClient = di.sl<ApiClient>();
        apiClient.setAuthToken(token);
        
        // Now make authenticated API call
        final response = await apiClient.get('/some-endpoint');
      }
    },
  );
}
```

### Example 3: Get User ID for Forms

```dart
Future<void> submitForm() async {
  final repository = di.sl<AuthRepository>();
  
  final userDescResult = await repository.getUserDescription();
  userDescResult.fold(
    (failure) => print('Error getting user data'),
    (userDesc) async {
      if (userDesc != null) {
        final formData = {
          'userId': userDesc.userId,
          'groupId': userDesc.groupId,
          'userName': userDesc.userName,
          // ... other form data
        };
        
        // Submit form with user data
        await apiClient.post('/submit-form', data: formData);
      }
    },
  );
}
```

### Example 4: Check User Permissions

```dart
Future<bool> canAccessFeature() async {
  final repository = di.sl<AuthRepository>();
  
  final userDescResult = await repository.getUserDescription();
  return userDescResult.fold(
    (failure) => false,
    (userDesc) {
      if (userDesc == null) return false;
      
      // Check based on designation
      if (userDesc.designation == 'Admin') {
        return true;
      }
      
      // Check based on BusinessInfoReq
      if (userDesc.businessInfoReq == 1) {
        return true;
      }
      
      return false;
    },
  );
}
```

---

## 📋 Complete User Data Structure

```dart
// Access saved login response
LoginResponseModel {
  bool success;
  String token;
  UserDescriptionModel userDescription;
}

// Access user description
UserDescriptionModel {
  String designation;        // "Credit Officer"
  String userBranch;         // "Branch"
  String userName;           // "ali arif "
  int userId;                // 91248
  int designationId;         // 1
  int groupId;               // 76
  int businessInfoReq;       // 1
  int loadUtByProduct;       // 0
}
```

---

## 🔄 Update Home Page to Use Real Data

Here's how to update your existing HomePage:

```dart
// In home_page.dart
import '../../../../injection_container.dart' as di;
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/data/models/login_response_model.dart';

class _HomePageState extends State<HomePage> {
  LoginResponseModel? _loginResponse;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final repository = di.sl<AuthRepository>();
    final result = await repository.getLoginResponse();
    
    result.fold(
      (failure) {
        // Handle error - maybe redirect to login
      },
      (loginResponse) {
        if (mounted) {
          setState(() {
            _loginResponse = loginResponse;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = _loginResponse?.userDescription.userName ?? widget.userName;
    final userRole = _loginResponse?.userDescription.designation ?? widget.userRole;
    
    return Scaffold(
      // Use userName and userRole from saved data
      // ...
    );
  }
}
```

---

## 🚨 Important Notes

1. **Always Check for Null**: Saved data might be null if user hasn't logged in
2. **Error Handling**: Always use `.fold()` to handle both success and failure cases
3. **Token Expiry**: Tokens might expire - handle token refresh if needed
4. **Data Sync**: Saved data is from last login - update it when needed
5. **Clear on Logout**: All data is cleared when user logs out

---

## 🎯 Quick Reference

```dart
// Get complete response
repository.getLoginResponse()

// Get user description only
repository.getUserDescription()

// Get token only
repository.getToken()

// All methods return Either<Failure, T>
// Use .fold() to handle both cases
```

---

**Now your app can access all saved user data throughout the application! 🎉**

