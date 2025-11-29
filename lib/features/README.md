# Features

This directory contains all feature modules of the RCDP Fast application. Each feature is organized following Clean Architecture principles.

## Current Features

### 1. Auth (`auth/`)
**Purpose**: User authentication and session management

**Screens**:
- Splash Screen - Initial loading screen
- Username Page - Username entry
- Login Page - Password authentication

**Key Components**:
- Local data storage for credentials
- BLoC for state management
- Custom reusable widgets (button, text field)

**Use Cases**:
- Login user
- Save username
- Get saved username

---

### 2. Home (`home/`)
**Purpose**: Main application dashboard and navigation

**Screens**:
- Home Page - Dashboard with menu grid and data cards
- Settings Page - App settings and user preferences
- Data Detail Page - Detailed view of data items
- Menu Detail Page - Detail view for menu items

**Features**:
- 8 main menu items (Client Disbursement, Approvals, etc.)
- 18 scrollable data cards (Active Areas, Active Branches, etc.)
- Settings with profile, admin panel, location, password change
- Special tracking page for "Clients Nearby"

---

## Feature Structure

Each feature follows this consistent structure:

```
feature_name/
├── data/                    # Data layer
│   ├── datasources/        # Data sources (local/remote)
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                  # Business logic layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
└── presentation/            # UI layer
    ├── bloc/               # State management
    ├── pages/              # Full screen pages
    └── widgets/            # Reusable widgets
```

## Adding a New Feature

1. **Create Directory Structure**
   ```bash
   mkdir -p lib/features/new_feature/{data,domain,presentation}/{datasources,repositories,entities,usecases,bloc,pages,widgets}
   ```

2. **Implement Domain Layer First**
   - Define entities
   - Create repository interfaces
   - Implement use cases

3. **Implement Data Layer**
   - Create data sources
   - Create models
   - Implement repositories

4. **Implement Presentation Layer**
   - Create BLoC (events, states, bloc)
   - Create pages
   - Create widgets

5. **Register Dependencies**
   - Add to `injection_container.dart`

6. **Add Navigation**
   - Connect from existing features

## Guidelines

- Keep features independent and loosely coupled
- Share common code through `core/` directory
- Use dependency injection for all dependencies
- Follow the existing naming conventions
- Write unit tests for business logic
- Document complex features

## Feature Dependencies

Features should depend on:
- ✅ Core utilities and constants
- ✅ Other features through well-defined interfaces
- ❌ Direct implementation details of other features

## State Management

All features use **BLoC pattern** for state management:
- Events: User actions
- States: UI states
- BLoC: Business logic coordinator

## Navigation

Navigation between features should be:
- Explicit and clear
- Handled in presentation layer
- Using MaterialPageRoute or named routes
