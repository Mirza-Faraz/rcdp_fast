# RCDP Fast

A Flutter application for managing credit officer operations with a focus on loan disbursement, recovery tracking, and client management.

## 📱 Features

- **Authentication**: Secure login with username and password
- **Dashboard**: Comprehensive overview with 8 main menu items
- **Data Tracking**: 18 different data metrics and KPIs
- **Client Management**: Track clients, disbursements, and recoveries
- **Reports**: Generate and view various reports
- **Settings**: Profile management and app configuration

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Get started quickly with the project
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Detailed project organization
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Clean Architecture implementation
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Complete setup instructions
- **[lib/core/README.md](lib/core/README.md)** - Core utilities documentation
- **[lib/features/README.md](lib/features/README.md)** - Features documentation

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC** pattern for state management.

### Layers
1. **Presentation** - UI components and state management
2. **Domain** - Business logic and entities
3. **Data** - Data sources and repositories

### Current Features
- **Auth** - User authentication and session management
- **Home** - Dashboard and main navigation

## 🛠️ Tech Stack

- **Framework**: Flutter 3.10.1+
- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Network**: dio
- **Local Storage**: shared_preferences
- **Functional Programming**: dartz
- **Value Equality**: equatable

## 📁 Project Structure

```
rcdp_fast/
├── lib/
│   ├── core/              # Shared utilities
│   │   ├── constants/     # Colors, dimensions, strings, styles
│   │   ├── error/         # Error handling
│   │   ├── network/       # Network utilities
│   │   ├── theme/         # App theming
│   │   ├── usecases/      # Base use cases
│   │   └── utils/         # Helper functions
│   │
│   ├── features/          # Feature modules
│   │   ├── auth/          # Authentication
│   │   └── home/          # Dashboard
│   │
│   ├── injection_container.dart
│   └── main.dart
│
├── assets/                # Images, icons, logos
├── test/                  # Tests
└── pubspec.yaml          # Dependencies
```

## 🎨 Design System

### Colors
- Primary: `#4B6FA5` (Blue)
- Background: White and light gray
- Text: White on primary, dark on light backgrounds

### Components
- Custom buttons with consistent styling
- Custom text fields with white borders
- Reusable card components
- Icon-based navigation

## 📱 Screens

### Authentication Flow
1. **Splash Screen** - App branding and initialization
2. **Username Page** - Username entry
3. **Login Page** - Password authentication

### Main Application
1. **Home Dashboard** - Menu grid and data cards
2. **Settings** - Profile, admin panel, location, password
3. **Data Details** - Detailed views for each metric
4. **Menu Items** - Specific functionality pages

## 🔧 Development

### Prerequisites
- Flutter SDK 3.10.1 or higher
- Dart SDK
- Android Studio / VS Code
- Git

### Setup
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

### Adding Features
1. Create feature directory in `lib/features/`
2. Follow Clean Architecture layers
3. Register dependencies in `injection_container.dart`
4. Add navigation from existing features

### Code Style
- Follow Dart style guide
- Use meaningful variable names
- Document complex logic
- Write unit tests for business logic

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Building

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Write/update tests
4. Submit a pull request

## 📄 License

[Add your license here]

## 👥 Team

[Add team members here]

## 📞 Support

For questions or issues, please contact the development team.

---

**Version**: 1.0.0+1  
**Last Updated**: November 2024
