# RCDP Fast - Project Structure

## Overview
This project follows Clean Architecture principles with a feature-based organization.

## Directory Structure

```
lib/
├── core/                           # Core functionality shared across features
│   ├── constants/                  # App-wide constants
│   │   ├── app_colors.dart        # Color palette
│   │   ├── app_dimensions.dart    # Spacing, sizes, radii
│   │   ├── app_strings.dart       # String constants
│   │   └── app_text_styles.dart   # Text style definitions
│   ├── error/                      # Error handling
│   │   ├── exceptions.dart        # Custom exceptions
│   │   └── failures.dart          # Failure classes
│   ├── network/                    # Network utilities
│   │   └── network_info.dart      # Network connectivity checker
│   ├── theme/                      # App theming
│   │   └── app_theme.dart         # Theme configuration
│   ├── usecases/                   # Base use case classes
│   │   └── usecase.dart           # UseCase interface
│   └── utils/                      # Utility functions
│       └── asset_helper.dart      # Asset path helpers
│
├── features/                       # Feature modules
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
│               ├── home_page.dart          # Main dashboard
│               ├── settings_page.dart      # Settings screen
│               ├── data_detail_page.dart   # Data detail view
│               └── menu_detail_page.dart   # Menu item detail view
│
├── injection_container.dart        # Dependency injection setup
└── main.dart                       # App entry point

assets/
├── icons/                          # App icons
│   ├── app_icon.png               # Main app icon
│   └── ICON_GUIDE.md              # Icon documentation
├── images/                         # Images
└── logos/                          # Logos
```

## Architecture Layers

### 1. Presentation Layer
- **Pages**: Full screen views
- **Widgets**: Reusable UI components
- **BLoC**: Business logic and state management

### 2. Domain Layer
- **Entities**: Business objects
- **Repositories**: Abstract repository interfaces
- **Use Cases**: Business logic operations

### 3. Data Layer
- **Data Sources**: Local and remote data sources
- **Models**: Data transfer objects
- **Repositories**: Repository implementations

## Feature Structure

Each feature follows this structure:
```
feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

## Current Features

### Auth Feature
Handles user authentication flow:
- Splash screen
- Username entry
- Login with password
- Local storage of credentials

### Home Feature
Main application dashboard:
- Dashboard with menu items
- Data visualization cards
- Settings management
- Detail views for each menu item

## Adding New Features

1. Create feature directory under `lib/features/`
2. Follow the three-layer architecture (data, domain, presentation)
3. Register dependencies in `injection_container.dart`
4. Add navigation from existing features

## Dependencies

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Network**: dio
- **Local Storage**: shared_preferences
- **Functional Programming**: dartz
- **Value Equality**: equatable

## Naming Conventions

- **Files**: snake_case (e.g., `auth_bloc.dart`)
- **Classes**: PascalCase (e.g., `AuthBloc`)
- **Variables**: camelCase (e.g., `userName`)
- **Constants**: camelCase with const (e.g., `const primaryColor`)

## Best Practices

1. Keep features independent
2. Use dependency injection
3. Follow SOLID principles
4. Write testable code
5. Use const constructors where possible
6. Implement proper error handling
7. Use meaningful variable names
8. Document complex logic
