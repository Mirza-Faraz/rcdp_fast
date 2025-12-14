# API Integration Guide for RCDP Fast

This guide explains how to integrate APIs in your Flutter app using Clean Architecture principles.

---

## 📚 Table of Contents

1. [Overview](#overview)
2. [Architecture Flow](#architecture-flow)
3. [Step-by-Step Implementation](#step-by-step-implementation)
4. [Login Example - Complete Flow](#login-example---complete-flow)
5. [Adding New APIs](#adding-new-apis)
6. [API Configuration](#api-configuration)
7. [Error Handling](#error-handling)
8. [Testing](#testing)

---

## 🎯 Overview

Your app follows **Clean Architecture** with three layers:

```
Presentation Layer (UI)
    ↓ calls
Domain Layer (Use Cases)
    ↓ calls
Data Layer (Repository)
    ↓ uses
Remote Data Source (API) + Local Data Source (Cache)
```

### Key Components:

1. **Models** (`data/models/`) - JSON serialization/deserialization
2. **Remote Data Source** (`data/datasources/`) - API calls
3. **Repository** (`data/repositories/`) - Coordinates remote + local
4. **Use Case** (`domain/usecases/`) - Business logic
5. **BLoC** (`presentation/bloc/`) - State management
6. **UI** (`presentation/pages/`) - User interface

---

## 🔄 Architecture Flow

### Login Flow Example:

```
LoginPage (UI)
    ↓ user clicks login
AuthBloc (State Management)
    ↓ dispatches LoginEvent
LoginUseCase (Business Logic)
    ↓ calls
AuthRepository (Data Abstraction)
    ↓ checks network
    ↓ if online: calls AuthRemoteDataSource
    ↓ if offline: uses AuthLocalDataSource
AuthRemoteDataSource (API Call)
    ↓ makes HTTP request via ApiClient
Backend API
    ↓ returns response
Response flows back up through layers
    ↓
AuthBloc emits new state
    ↓
UI updates
```

---

## 📝 Step-by-Step Implementation

### Step 1: Define API Endpoints

**File:** `lib/core/constants/api_endpoints.dart`

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://your-api-domain.com/api/v1';
  static const String login = '/auth/login';
  // Add more endpoints...
}
```

**Update the base URL** to match your backend API.

---

### Step 2: Create Models

**File:** `lib/features/auth/data/models/login_request_model.dart`

```dart
class LoginRequestModel {
  final String username;
  final String password;
  
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
```

**File:** `lib/features/auth/data/models/login_response_model.dart`

```dart
class LoginResponseModel {
  final bool success;
  final String message;
  final String? token;
  
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}
```

**Purpose:** Convert between JSON (API format) and Dart objects.

---

### Step 3: Create Remote Data Source

**File:** `lib/features/auth/data/datasources/auth_remote_data_source.dart`

```dart
abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  
  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    
    return LoginResponseModel.fromJson(response.data);
  }
}
```

**Purpose:** Makes actual HTTP requests to your backend API.

---

### Step 4: Update Repository

**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  @override
  Future<Either<Failure, bool>> login(String username, String password) async {
    // Check internet connection
    if (await networkInfo.isConnected) {
      try {
        // Call API
        final request = LoginRequestModel(username: username, password: password);
        final response = await remoteDataSource.login(request);
        
        if (response.success) {
          // Save to local storage
          await localDataSource.saveUsername(username);
          await localDataSource.saveLoginStatus(true);
          return const Right(true);
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
```

**Purpose:** Coordinates between API calls and local storage, handles errors.

---

### Step 5: Use Case (Already Exists)

**File:** `lib/features/auth/domain/usecases/login_usecase.dart`

```dart
class LoginUseCase {
  final AuthRepository repository;
  
  Future<Either<Failure, bool>> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
```

**Purpose:** Single responsibility business logic unit.

---

### Step 6: BLoC (Already Exists)

**File:** `lib/features/auth/presentation/bloc/auth_bloc.dart`

The BLoC already handles the login event. No changes needed!

```dart
Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  
  final result = await loginUseCase(event.username, event.password);
  
  result.fold(
    (failure) => emit(AuthError(message: failure.message)),
    (success) => emit(AuthAuthenticated(username: event.username)),
  );
}
```

---

### Step 7: UI (Already Exists)

**File:** `lib/features/auth/presentation/pages/login_page.dart`

The UI already dispatches the login event. No changes needed!

```dart
CustomButton(
  text: 'Login',
  onPressed: () {
    context.read<AuthBloc>().add(
      LoginEvent(username: username, password: password),
    );
  },
)
```

---

## 🔐 Login Example - Complete Flow

### What Happens When User Clicks Login:

1. **UI Layer:**
   ```dart
   // User enters credentials and clicks "Login"
   context.read<AuthBloc>().add(LoginEvent(username: 'john', password: '123'));
   ```

2. **BLoC Layer:**
   ```dart
   // Emits loading state
   emit(AuthLoading());
   
   // Calls use case
   final result = await loginUseCase('john', '123');
   ```

3. **Use Case Layer:**
   ```dart
   // Calls repository
   return await repository.login('john', '123');
   ```

4. **Repository Layer:**
   ```dart
   // Checks network
   if (await networkInfo.isConnected) {
     // Creates request model
     final request = LoginRequestModel(username: 'john', password: '123');
     
     // Calls remote data source
     final response = await remoteDataSource.login(request);
     
     // Saves to local storage if successful
     await localDataSource.saveUsername('john');
   }
   ```

5. **Remote Data Source:**
   ```dart
   // Makes HTTP POST request
   final response = await apiClient.post(
     ApiEndpoints.login,  // '/auth/login'
     data: {'username': 'john', 'password': '123'},
   );
   
   // Parses response
   return LoginResponseModel.fromJson(response.data);
   ```

6. **Response Flows Back:**
   ```
   API Response → Remote Data Source → Repository → Use Case → BLoC → UI
   ```

---

## ➕ Adding New APIs

### Example: Adding "Get User Profile" API

#### Step 1: Add Endpoint
```dart
// lib/core/constants/api_endpoints.dart
static const String getUserProfile = '/user/profile';
```

#### Step 2: Create Models
```dart
// lib/features/auth/data/models/user_profile_model.dart
class UserProfileModel {
  final String username;
  final String email;
  final String role;
  
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}
```

#### Step 3: Add to Remote Data Source
```dart
// lib/features/auth/data/datasources/auth_remote_data_source.dart
Future<UserProfileModel> getUserProfile() async {
  final response = await apiClient.get(ApiEndpoints.getUserProfile);
  return UserProfileModel.fromJson(response.data);
}
```

#### Step 4: Add to Repository Interface
```dart
// lib/features/auth/domain/repositories/auth_repository.dart
Future<Either<Failure, UserProfileModel>> getUserProfile();
```

#### Step 5: Implement in Repository
```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
@override
Future<Either<Failure, UserProfileModel>> getUserProfile() async {
  if (await networkInfo.isConnected) {
    try {
      final profile = await remoteDataSource.getUserProfile();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  } else {
    return const Left(NetworkFailure('No internet connection'));
  }
}
```

#### Step 6: Create Use Case
```dart
// lib/features/auth/domain/usecases/get_user_profile_usecase.dart
class GetUserProfileUseCase {
  final AuthRepository repository;
  
  Future<Either<Failure, UserProfileModel>> call() async {
    return await repository.getUserProfile();
  }
}
```

#### Step 7: Add to BLoC (if needed)
```dart
// Add event
class GetUserProfileEvent extends AuthEvent {}

// Add handler
on<GetUserProfileEvent>(_onGetUserProfile);

Future<void> _onGetUserProfile(...) async {
  final result = await getUserProfileUseCase();
  // Handle result...
}
```

#### Step 8: Use in UI
```dart
// In your page
context.read<AuthBloc>().add(GetUserProfileEvent());
```

---

## ⚙️ API Configuration

### Setting Base URL

**File:** `lib/core/constants/api_endpoints.dart`

```dart
class ApiEndpoints {
  // For development
  static const String baseUrl = 'https://dev-api.example.com/api/v1';
  
  // For production (you can use environment variables)
  // static const String baseUrl = 'https://api.example.com/api/v1';
}
```

### Setting Timeout

**File:** `lib/core/network/api_client.dart`

```dart
BaseOptions(
  baseUrl: ApiEndpoints.baseUrl,
  connectTimeout: const Duration(seconds: 30),  // Connection timeout
  receiveTimeout: const Duration(seconds: 30),  // Response timeout
)
```

### Adding Headers

**File:** `lib/core/network/api_client.dart`

```dart
headers: {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Version': '1.0.0',  // Custom header
}
```

---

## 🚨 Error Handling

### Error Types:

1. **NetworkException** - No internet, timeout
2. **ServerException** - API errors (400, 401, 500, etc.)
3. **CacheException** - Local storage errors

### How Errors Flow:

```
API Error → Exception → Repository → Failure → Use Case → BLoC → UI
```

### Example Error Handling:

```dart
try {
  final response = await apiClient.post(ApiEndpoints.login, data: data);
  // Success
} on ServerException catch (e) {
  // Handle server error (400, 401, 500, etc.)
  return Left(ServerFailure(e.message));
} on NetworkException catch (e) {
  // Handle network error (no internet, timeout)
  return Left(NetworkFailure(e.message));
} catch (e) {
  // Handle unexpected errors
  return Left(ServerFailure('Unexpected error: ${e.toString()}'));
}
```

---

## 🧪 Testing

### Testing API Calls:

1. **Mock Remote Data Source:**
```dart
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    // Return mock response
    return LoginResponseModel(
      success: true,
      message: 'Login successful',
      token: 'mock_token',
    );
  }
}
```

2. **Test Repository:**
```dart
test('should return success when login is successful', () async {
  // Arrange
  when(mockRemoteDataSource.login(any))
    .thenAnswer((_) async => mockLoginResponse);
  
  // Act
  final result = await repository.login('john', '123');
  
  // Assert
  expect(result, Right(true));
});
```

---

## 📋 Checklist for Adding New API

- [ ] Add endpoint to `api_endpoints.dart`
- [ ] Create request model (if needed)
- [ ] Create response model
- [ ] Add method to remote data source interface
- [ ] Implement method in remote data source
- [ ] Add method to repository interface
- [ ] Implement method in repository (with error handling)
- [ ] Create use case (if needed)
- [ ] Register in dependency injection
- [ ] Add BLoC events/states (if needed)
- [ ] Use in UI

---

## 🔧 Common API Patterns

### GET Request:
```dart
final response = await apiClient.get(
  ApiEndpoints.getClients,
  queryParameters: {'page': 1, 'limit': 10},
);
```

### POST Request:
```dart
final response = await apiClient.post(
  ApiEndpoints.createClient,
  data: {'name': 'John', 'email': 'john@example.com'},
);
```

### PUT Request:
```dart
final response = await apiClient.put(
  ApiEndpoints.updateClient,
  data: {'id': 1, 'name': 'John Updated'},
);
```

### DELETE Request:
```dart
final response = await apiClient.delete(
  ApiEndpoints.deleteClient,
);
```

### With Authorization Token:
```dart
// Token is automatically added by ApiClient after login
// You can also manually set it:
apiClient.setAuthToken('your_token_here');
```

---

## 🎯 Key Points to Remember

1. **Always use Models** - Never pass raw JSON to your UI
2. **Handle Errors** - Wrap API calls in try-catch
3. **Check Network** - Always check connectivity before API calls
4. **Save Locally** - Cache important data for offline access
5. **Use Repository Pattern** - Repository decides remote vs local
6. **Follow Clean Architecture** - Keep layers separate
7. **Test Your Code** - Write unit tests for API calls

---

## 🚀 Quick Start Example

To integrate an API in your login screen:

1. **Update Base URL:**
   ```dart
   // lib/core/constants/api_endpoints.dart
   static const String baseUrl = 'YOUR_API_BASE_URL';
   ```

2. **Run:**
   ```bash
   flutter pub get
   ```

3. **Test Login:**
   - Open app
   - Enter username/password
   - Click login
   - Check logs for API request/response

4. **Check Logs:**
   - Dio automatically logs all requests/responses
   - Look for logs in your console

---

## 📞 API Response Format Expected

Your API should return JSON in this format:

**Success Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "username": "john",
    "userId": "123",
    "role": "Credit Officer",
    "email": "john@example.com"
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

**Adjust the models** (`login_response_model.dart`) if your API returns different format.

---

## 🔍 Debugging Tips

1. **Check Network Logs:**
   - Dio logs all requests/responses automatically
   - Look in console for `[Dio]` logs

2. **Check Base URL:**
   - Make sure `api_endpoints.dart` has correct base URL

3. **Check Response Format:**
   - Ensure your models match API response structure

4. **Check Network Connection:**
   - Test with internet on/off

5. **Check Error Messages:**
   - Read error messages in BLoC states
   - Check server response in logs

---

## 📚 Additional Resources

- [Dio Documentation](https://pub.dev/packages/dio)
- [Clean Architecture Guide](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [BLoC Pattern](https://bloclibrary.dev/)

---

**Happy Coding! 🚀**


