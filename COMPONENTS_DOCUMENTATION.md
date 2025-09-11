# OneStopRx Driver - Reusable Components Documentation

This document describes the reusable components created for the OneStopRx Driver app, based on the Figma design specifications.

## 🎨 Theme System

### Color Palette (`app_colors.dart`)
- **Primary Colors**: Dark navy (`#000D1C`), Blue (`#077BF8`), Brand Green (`#1D9C7D`)
- **Neutral Colors**: White, Black, Gray variants
- **Button Colors**: Specific colors for different button types
- **Status Colors**: Success, Error, Warning, Info

### Text Styles (`app_text_styles.dart`)
- **Font Families**: Onest, Inter, Plus Jakarta Sans
- **Logo Styles**: Large and small logo text styles
- **Heading Styles**: Large, Medium, Small headings
- **Button Text**: Primary and secondary button text styles
- **Body Text**: Large, Medium, Small body text
- **Label Styles**: Various label sizes

### App Theme (`app_theme.dart`)
Complete Material 3 theme configuration with:
- Light theme setup
- Color scheme configuration
- Typography setup
- Button themes (Elevated, Outlined, Text)
- Input decoration theme

## 🔧 Reusable Components

### 1. AppButton (`app_button.dart`)

A comprehensive button component with multiple variants.

#### Features
- Three button types: Primary, Secondary, Tertiary
- Three sizes: Small, Medium, Large
- Loading state support
- Disabled state support
- Left and right icon support
- Full width or custom width
- Custom margins

#### Usage Examples

```dart
// Primary button
AppButton(
  text: 'Log In',
  type: AppButtonType.primary,
  onPressed: () => _handleLogin(),
)

// Secondary button with loading
AppButton(
  text: 'Sign Up',
  type: AppButtonType.secondary,
  isLoading: true,
  onPressed: () => _handleSignUp(),
)

// Tertiary button with icon
AppButton(
  text: 'Continue',
  type: AppButtonType.tertiary,
  rightIcon: Icon(Icons.arrow_forward),
  onPressed: () => _handleContinue(),
)
```

#### Button Types
- **Primary**: Dark background with white text
- **Secondary**: Light blue background with blue text
- **Tertiary**: Transparent background with blue text

### 2. AppLogo (`app_logo.dart`)

Flexible logo component matching the Figma design.

#### Features
- Three display types: Full logo, Icon only, Text only
- Three sizes: Small, Medium, Large
- Custom colors for icon and text
- Responsive sizing based on screen dimensions

#### Usage Examples

```dart
// Full logo (default)
AppLogo(
  type: LogoType.full,
  size: LogoSize.medium,
)

// Icon only
AppLogo(
  type: LogoType.iconOnly,
  size: LogoSize.small,
  iconColor: Colors.white,
)

// Text only with custom color
AppLogo(
  type: LogoType.textOnly,
  textColor: Colors.blue,
)
```

### 3. CountrySelector (`country_selector.dart`)

Interactive country selection component with flag display.

#### Features
- Primary and secondary flag display (Nigeria and US style)
- Bottom sheet selection modal
- Pre-defined country list with flags
- Callback for country changes
- Visual feedback for selected country

#### Usage Examples

```dart
CountrySelector(
  selectedCountry: selectedCountry,
  countries: CountrySelector.defaultCountries,
  onCountryChanged: (country) {
    setState(() {
      selectedCountry = country;
    });
  },
)
```

#### Default Countries
- Nigeria 🇳🇬
- United States 🇺🇸
- United Kingdom 🇬🇧
- Canada 🇨🇦
- Ghana 🇬🇭
- Kenya 🇰🇪
- South Africa 🇿🇦

### 4. AppStatusBar (`app_status_bar.dart`)

Custom status bar component with system integration.

#### Features
- Time display
- WiFi signal indicator
- Network strength indicator
- Battery level indicator
- Dark/Light mode support
- System UI overlay style configuration

#### Usage Examples

```dart
AppStatusBar(
  time: '12:30',
  isDarkMode: false,
)
```

## 📱 AuthScreen Implementation

The `AuthScreen` (`auth_screen.dart`) demonstrates the complete integration of all components to match the Figma design.

### Screen Structure
1. **Status Bar**: Custom status bar with time and system indicators
2. **Header**: Logo and country selector
3. **Hero Image**: Full-width ambulance image
4. **Content**: Main heading text
5. **Action Buttons**: Three button variants (Log In, Sign Up, Continue)
6. **Navigation Bar**: Android-style navigation handle

### Key Features
- Responsive design using size utilities
- Proper spacing and typography
- State management for country selection
- Navigation handlers for each button
- Exact color and font matching from Figma

## 🎯 Design System Benefits

### Consistency
- All components follow the same design principles
- Consistent spacing, colors, and typography
- Unified interaction patterns

### Reusability
- Components can be used across different screens
- Configurable properties for different use cases
- Easy to maintain and update

### Accessibility
- Proper contrast ratios
- Responsive text sizing
- Touch-friendly button sizes

### Performance
- Efficient rendering with minimal rebuilds
- Optimized asset usage
- Clean widget tree structure

## 🚀 Usage Guidelines

### Import Structure
```dart
// Theme
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_theme.dart';

// Widgets
import '../widgets/app_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/country_selector.dart';

// Utilities
import '../util/size_utils.dart';
import '../util/image_constant.dart';
```

### Best Practices
1. **Use responsive extensions**: Always use `.h`, `.v`, `.fSize` for responsive sizing
2. **Follow component hierarchy**: Use appropriate text styles for different content types
3. **Maintain consistency**: Use defined colors and spacing throughout the app
4. **Handle states**: Always provide loading and disabled states for interactive components
5. **Accessibility**: Ensure proper contrast and touch targets

## 🎨 Figma Design Matching

All components are designed to exactly match the Figma specifications:
- **Colors**: Exact hex values from Figma color tokens
- **Typography**: Font families, sizes, weights, and line heights
- **Spacing**: Precise padding, margins, and gaps
- **Border Radius**: Rounded corners with exact radius values
- **Icons**: Custom-drawn icons to match Figma designs
- **Layout**: Proper alignment and responsive behavior

This component system provides a solid foundation for building the complete OneStopRx Driver application while maintaining design consistency and code reusability.
