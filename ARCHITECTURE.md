# Clean Architecture with BLoC

This project follows Clean Architecture principles with BLoC state management.

## Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── error/                     # Error handling
│   │   ├── exceptions.dart        # Custom exceptions
│   │   └── failures.dart          # Failure classes
│   ├── network/                   # Network utilities
│   │   └── network_info.dart      # Network connectivity
│   └── usecases/                  # Base use case
│       └── usecase.dart           # UseCase interface
│
├── features/                      # Feature modules
│   └── example/                   # Example feature
│       ├── data/                  # Data layer
│       │   ├── datasources/       # Data sources
│       │   │   ├── example_local_data_source.dart
│       │   │   └── example_remote_data_source.dart
│       │   ├── models/            # Data models
│       │   │   └── example_model.dart
│       │   └── repositories/      # Repository implementations
│       │       └── example_repository_impl.dart
│       │
│       ├── domain/                # Domain layer
│       │   ├── entities/          # Business entities
│       │   │   └── example_entity.dart
│       │   ├── repositories/      # Repository interfaces
│       │   │   └── example_repository.dart
│       │   └── usecases/          # Business logic
│       │       └── get_examples.dart
│       │
│       └── presentation/          # Presentation layer
│           ├── bloc/              # BLoC state management
│           │   ├── example_bloc.dart
│           │   ├── example_event.dart
│           │   └── example_state.dart
│           └── pages/             # UI pages
│               └── example_page.dart
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
