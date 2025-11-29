# Clean Architecture with BLoC

This project follows Clean Architecture principles with BLoC state management.

## Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── constants/                 # App-wide constants
│   │   ├── app_colors.dart        # Color palette
│   │   ├── app_dimensions.dart    # Spacing and sizes
│   │   ├── app_strings.dart       # String constants
│   │   └── app_text_styles.dart   # Text styles
│   ├── error/                     # Error handling
│   │   ├── exceptions.dart        # Custom exceptions
│   │   └── failures.dart          # Failure classes
│   ├── network/                   # Network utilities
│   │   └── network_info.dart      # Network connectivity
│   ├── theme/                     # App theming
│   │   └── app_theme.dart         # Theme configuration
│   ├── usecases/                  # Base use case
│   │   └── usecase.dart           # UseCase interface
│   └── utils/                     # Utility functions
│       └── asset_helper.dart      # Asset path helpers
│
├── features/                      # Feature modules
│   ├── auth/                      # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_saved_username_usecase.dart
│   │   │       ├── login_usecase.dart
│   │   │       └── save_username_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── splash_page.dart
│   │       │   ├── username_page.dart
│   │       │   └── login_page.dart
│   │       └── widgets/
│   │           ├── custom_button.dart
│   │           └── custom_text_field.dart
│   │
│   └── home/                      # Home/Dashboard feature
│       └── presentation/
│           └── pages/
│               ├── home_page.dart
│               ├── settings_page.dart
│               ├── data_detail_page.dart
│               └── menu_detail_page.dart
│
├── injection_container.dart       # Dependency injection setup
└── main.dart                      # App entry point
```

## Layers

### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: Single-responsibility business logic units

### 2. Data Layer
- **Models**: Data transfer objects extending entities
- **Data Sources**: Remote (API) and Local (Cache) data sources
- **Repository Implementations**: Concrete implementations of domain repositories

### 3. Presentation Layer
- **BLoC**: State management (Events, States, BLoC)
- **Pages**: UI screens
- **Widgets**: Reusable UI components

## Key Packages

- **flutter_bloc**: State management
- **equatable**: Value equality
- **get_it**: Dependency injection
- **dio**: HTTP client
- **dartz**: Functional programming (Either type)
- **shared_preferences**: Local storage

## How to Add a New Feature

1. Create feature folder: `lib/features/your_feature/`
2. Add domain layer:
   - Entity in `domain/entities/`
   - Repository interface in `domain/repositories/`
   - Use case in `domain/usecases/`
3. Add data layer:
   - Model in `data/models/`
   - Data sources in `data/datasources/`
   - Repository implementation in `data/repositories/`
4. Add presentation layer:
   - BLoC files in `presentation/bloc/`
   - Pages in `presentation/pages/`
5. Register dependencies in `injection_container.dart`

## Running the App

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```
