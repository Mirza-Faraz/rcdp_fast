# API Integration Quick Reference

## 🎯 Where Everything Goes

```
lib/
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart          ← Define all API URLs here
│   └── network/
│       ├── api_client.dart             ← HTTP client configuration
│       └── network_info.dart           ← Check internet connection
│
└── features/
    └── auth/
        └── data/
            ├── models/                 ← JSON models (Request/Response)
            │   ├── login_request_model.dart
            │   └── login_response_model.dart
            ├── datasources/            ← API calls here
            │   └── auth_remote_data_source.dart
            └── repositories/
                └── auth_repository_impl.dart  ← Coordinates API + Local
```

---

## 📞 Login API Flow Diagram

```
┌─────────────────┐
│   LoginPage     │  User enters credentials
│      (UI)       │
└────────┬────────┘
         │ dispatch LoginEvent
         ▼
┌─────────────────┐
│   AuthBloc      │  Manages state
│  (State Mgmt)   │
└────────┬────────┘
         │ calls loginUseCase
         ▼
┌─────────────────┐
│  LoginUseCase   │  Business logic
│  (Domain)       │
└────────┬────────┘
         │ calls repository.login()
         ▼
┌─────────────────┐
│AuthRepository   │  Checks network, coordinates
│  (Data Layer)   │
└────────┬────────┘
         │ if online → calls remoteDataSource
         ▼
┌─────────────────┐
│AuthRemoteData   │  Makes HTTP request
│    Source       │
└────────┬────────┘
         │ uses ApiClient
         ▼
┌─────────────────┐
│   ApiClient     │  Dio HTTP client
│   (Dio)         │
└────────┬────────┘
         │ POST /auth/login
         ▼
┌─────────────────┐
│  Backend API    │  Your server
│   Server        │
└─────────────────┘
```

---

## 🔄 Method Call Sequence

### When Login Button is Clicked:

1. **UI:** `LoginPage` → dispatches `LoginEvent`
2. **BLoC:** `AuthBloc` → calls `loginUseCase.call()`
3. **Use Case:** `LoginUseCase` → calls `repository.login()`
4. **Repository:** `AuthRepositoryImpl` → checks network
5. **If Online:**
   - Creates `LoginRequestModel`
   - Calls `remoteDataSource.login()`
6. **Remote Data Source:** `AuthRemoteDataSourceImpl` → calls `apiClient.post()`
7. **API Client:** Makes HTTP POST request
8. **Response flows back up** → BLoC → UI updates

---

## 🛠️ What You Need to Do

### 1. Set Your API Base URL

**File:** `lib/core/constants/api_endpoints.dart`

```dart
static const String baseUrl = 'https://YOUR-API-URL.com/api/v1';
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Update API Response Model (if needed)

**File:** `lib/features/auth/data/models/login_response_model.dart`

Adjust the `fromJson` method to match your API's response format.

### 4. Test!

The login screen is already connected. Just:
- Enter username/password
- Click login
- Check console logs for API request/response

---

## 📝 File Responsibilities

| File | What It Does |
|------|-------------|
| `api_endpoints.dart` | Stores all API URLs |
| `api_client.dart` | Configures Dio, handles requests |
| `login_request_model.dart` | Converts username/password to JSON |
| `login_response_model.dart` | Converts API response to Dart object |
| `auth_remote_data_source.dart` | Makes actual API calls |
| `auth_repository_impl.dart` | Coordinates API + local storage |
| `auth_bloc.dart` | Manages login state |
| `login_page.dart` | UI that triggers login |

---

## ✅ Checklist

- [x] API endpoints defined
- [x] Models created (Request/Response)
- [x] Remote data source implemented
- [x] Repository updated to use API
- [x] Dependency injection configured
- [x] Network checking added
- [ ] **YOU: Update base URL**
- [ ] **YOU: Install dependencies** (`flutter pub get`)
- [ ] **YOU: Test login**

---

## 🚀 Quick Test

1. Update base URL in `api_endpoints.dart`
2. Run `flutter pub get`
3. Start your app
4. Try logging in
5. Check console for API logs (Dio automatically logs everything)

---

## 📞 Adding Another API?

Follow the same pattern:

1. Add endpoint → `api_endpoints.dart`
2. Create models → `data/models/`
3. Add to remote data source → `data/datasources/`
4. Add to repository → `data/repositories/`
5. Create use case → `domain/usecases/`
6. Use in BLoC/UI

See `API_INTEGRATION_GUIDE.md` for detailed examples!


