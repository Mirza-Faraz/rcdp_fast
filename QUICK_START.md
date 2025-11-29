# RCDP Fast - Quick Start Guide

## Project Overview

RCDP Fast is a Flutter application for managing credit officer operations, built with Clean Architecture and BLoC pattern.

## Getting Started

### Prerequisites
- Flutter SDK (3.10.1 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS development tools (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd rcdp_fast
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
rcdp_fast/
├── lib/
│   ├── core/              # Shared utilities and constants
│   ├── features/          # Feature modules
│   ├── injection_container.dart
│   └── main.dart
├── assets/                # Images, icons, logos
├── test/                  # Unit and widget tests
└── pubspec.yaml          # Dependencies
```

## Key Features

### 1. Authentication
- Splash screen with app branding
- Username entry
- Password login
- Local credential storage

### 2. Dashboard
- 8 main menu items for different operations
- 18 data cards showing key metrics
- Real-time data updates
- Settings and profile management

### 3. Menu Items
- Client Disbursement
- Approvals
- Follow Up Clients
- Recovery Form
- Overdue Clients
- Clients Nearby (with tracking)
- Reports
- Loan Trearing List

## Architecture

### Clean Architecture Layers

1. **Presentation Layer**
   - UI components (Pages, Widgets)
   - State management (BLoC)
   - User interactions

2. **Domain Layer**
   - Business logic (Use Cases)
   - Business entities
   - Repository interfaces

3. **Data Layer**
   - Data sources (Local, Remote)
   - Repository implementations
   - Data models

### State Management

Using **BLoC Pattern**:
- Events: User actions
- States: UI states
- BLoC: Business logic

## Common Tasks

### Adding a New Screen

1. Create page file in `lib/features/[feature]/presentation/pages/`
2. Create necessary widgets in `widgets/` folder
3. Add navigation from existing screens
4. Update BLoC if needed

### Adding a New Feature

1. Create feature directory structure
2. Implement domain layer (entities, repositories, use cases)
3. Implement data layer (data sources, models, repository impl)
4. Implement presentation layer (BLoC, pages, widgets)
5. Register dependencies in `injection_container.dart`

### Using Constants

```dart
// Colors
import 'package:rcdp_fast/core/constants/app_colors.dart';
color: AppColors.primary

// Dimensions
import 'package:rcdp_fast/core/constants/app_dimensions.dart';
padding: EdgeInsets.all(AppDimensions.paddingMedium)

// Strings
import 'package:rcdp_fast/core/constants/app_strings.dart';
Text(AppStrings.appName)

// Text Styles
import 'package:rcdp_fast/core/constants/app_text_styles.dart';
style: AppTextStyles.h1
```

## Development Workflow

1. **Create feature branch**
   ```bash
   git checkout -b feature/feature-name
   ```

2. **Make changes**
   - Follow existing patterns
   - Use constants from core
   - Write clean, documented code

3. **Test your changes**
   ```bash
   flutter test
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Commit and push**
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin feature/feature-name
   ```

## Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

### Common Issues

1. **Dependencies not found**
   ```bash
   flutter pub get
   flutter clean
   flutter pub get
   ```

2. **Build errors**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Hot reload not working**
   - Press 'r' in terminal for hot reload
   - Press 'R' for hot restart

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## Project Documentation

- `PROJECT_STRUCTURE.md` - Detailed project structure
- `ARCHITECTURE.md` - Architecture documentation
- `lib/core/README.md` - Core utilities documentation
- `lib/features/README.md` - Features documentation
- `SETUP_GUIDE.md` - Setup instructions

## Contact

For questions or issues, please contact the development team.
