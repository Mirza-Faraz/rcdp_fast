# Core

This directory contains shared functionality used across all features of the application.

## Directory Structure

```
core/
├── constants/          # Application-wide constants
├── error/             # Error handling utilities
├── network/           # Network utilities
├── theme/             # App theming
├── usecases/          # Base use case classes
└── utils/             # Utility functions
```

## Contents

### Constants (`constants/`)

#### `app_colors.dart`
Defines the color palette for the entire application.

**Usage**:
```dart
import 'package:rcdp_fast/core/constants/app_colors.dart';

Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

**Available Colors**:
- Primary colors: `primary`, `primaryDark`, `primaryLight`
- Background colors: `background`, `backgroundLight`, `backgroundDark`
- Text colors: `textPrimary`, `textSecondary`, `textDark`, `textHint`
- Button colors: `buttonPrimary`, `buttonText`, `buttonDisabled`
- Status colors: `success`, `error`, `warning`, `info`
- Border colors: `border`, `borderLight`
- Basic colors: `white`, `black`, `transparent`

---

#### `app_dimensions.dart`
Defines spacing, sizing, and dimension constants.

**Usage**:
```dart
import 'package:rcdp_fast/core/constants/app_dimensions.dart';

Padding(
  padding: EdgeInsets.all(AppDimensions.paddingMedium),
  child: Container(
    height: AppDimensions.buttonHeight,
  ),
)
```

**Available Dimensions**:
- Padding: `paddingSmall`, `paddingMedium`, `paddingLarge`, `paddingXLarge`
- Margin: `marginSmall`, `marginMedium`, `marginLarge`, `marginXLarge`
- Border Radius: `radiusSmall`, `radiusMedium`, `radiusLarge`, `radiusXLarge`
- Icon Sizes: `iconSmall`, `iconMedium`, `iconLarge`, `iconXLarge`
- Button Heights: `buttonHeight`, `buttonHeightSmall`

---

#### `app_strings.dart`
Centralized string constants for the application.

**Usage**:
```dart
import 'package:rcdp_fast/core/constants/app_strings.dart';

Text(AppStrings.appName)
```

**Categories**:
- App strings
- Auth strings
- Error messages
- Settings strings

---

#### `app_text_styles.dart`
Predefined text styles for consistent typography.

**Usage**:
```dart
import 'package:rcdp_fast/core/constants/app_text_styles.dart';

Text(
  'Heading',
  style: AppTextStyles.h1,
)
```

**Available Styles**:
- Headings: `h1`, `h2`, `h3`
- Body: `bodyLarge`, `bodyMedium`, `bodySmall`
- Button: `button`
- Caption: `caption`

---

### Error (`error/`)

#### `exceptions.dart`
Custom exception classes for different error scenarios.

**Available Exceptions**:
- `ServerException` - Server-side errors
- `CacheException` - Local storage errors
- `NetworkException` - Network connectivity errors

---

#### `failures.dart`
Failure classes for error handling in the domain layer.

**Available Failures**:
- `ServerFailure` - Server-side failures
- `CacheFailure` - Local storage failures
- `NetworkFailure` - Network connectivity failures

---

### Network (`network/`)

#### `network_info.dart`
Utility for checking network connectivity.

**Usage**:
```dart
final hasConnection = await networkInfo.isConnected;
```

---

### Theme (`theme/`)

#### `app_theme.dart`
Application theme configuration.

**Usage**:
```dart
import 'package:rcdp_fast/core/theme/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme,
  // ...
)
```

---

### Use Cases (`usecases/`)

#### `usecase.dart`
Base class for all use cases in the application.

**Usage**:
```dart
class MyUseCase extends UseCase<ReturnType, Params> {
  @override
  Future<Either<Failure, ReturnType>> call(Params params) async {
    // Implementation
  }
}
```

---

### Utils (`utils/`)

#### `asset_helper.dart`
Helper functions for accessing asset paths.

**Usage**:
```dart
import 'package:rcdp_fast/core/utils/asset_helper.dart';

Image.asset(AssetHelper.appIcon)
Image.asset(AssetHelper.getImage('logo.png'))
```

**Available Methods**:
- `getImage(name)` - Get image path
- `getIcon(name)` - Get icon path
- `getLogo(name)` - Get logo path

---

## Best Practices

1. **Constants**: Always use constants from `core/constants/` instead of hardcoding values
2. **Colors**: Use `AppColors` for all color values
3. **Spacing**: Use `AppDimensions` for consistent spacing
4. **Text Styles**: Use `AppTextStyles` for typography
5. **Errors**: Use custom exceptions and failures for error handling
6. **Assets**: Use `AssetHelper` for asset paths

## Adding New Core Utilities

When adding new shared functionality:

1. Determine the appropriate subdirectory
2. Create a new file with a descriptive name
3. Document the usage with examples
4. Update this README
5. Ensure it's truly shared across features (not feature-specific)

## Guidelines

- Keep core utilities generic and reusable
- Don't add feature-specific code here
- Document all public APIs
- Use meaningful names
- Follow existing patterns
