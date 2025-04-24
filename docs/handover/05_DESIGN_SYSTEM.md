# Design System

## Color Palette

### Primary Colors
```dart
static const Color primary = Color(0xFF0036FF);
static const Color primaryVariant = Color(0xFF0028CC);
static const Color secondary = Color(0xFF03DAC6);
static const Color secondaryVariant = Color(0xFF018786);
```

### Neutral Colors
```dart
static const Color background = Color(0xFFF5F5F5);
static const Color surface = Color(0xFFFFFFFF);
static const Color error = Color(0xFFB00020);
```

### Text Colors
```dart
static const Color onPrimary = Color(0xFFFFFFFF);
static const Color onSecondary = Color(0xFF000000);
static const Color onBackground = Color(0xFF000000);
static const Color onSurface = Color(0xFF000000);
static const Color onError = Color(0xFFFFFFFF);
```

## Typography

### Font Family
```dart
static const String fontFamily = 'Pretendard';
```

### Text Styles
```dart
static const TextStyle headline1 = TextStyle(
  fontSize: 96,
  fontWeight: FontWeight.light,
  letterSpacing: -1.5,
);

static const TextStyle headline2 = TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.light,
  letterSpacing: -0.5,
);

static const TextStyle headline3 = TextStyle(
  fontSize: 48,
  fontWeight: FontWeight.normal,
  letterSpacing: 0,
);

static const TextStyle headline4 = TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.normal,
  letterSpacing: 0.25,
);

static const TextStyle headline5 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.normal,
  letterSpacing: 0,
);

static const TextStyle headline6 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.medium,
  letterSpacing: 0.15,
);

static const TextStyle body1 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  letterSpacing: 0.5,
);

static const TextStyle body2 = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  letterSpacing: 0.25,
);
```

## Spacing

### Grid System
```dart
static const double spacingUnit = 8.0;

static const double spacingXS = spacingUnit * 0.5;  // 4
static const double spacingS = spacingUnit;         // 8
static const double spacingM = spacingUnit * 2;     // 16
static const double spacingL = spacingUnit * 3;     // 24
static const double spacingXL = spacingUnit * 4;    // 32
```

## Components

### Buttons
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.primary,
    onPrimary: Colors.onPrimary,
    padding: EdgeInsets.symmetric(
      horizontal: spacingM,
      vertical: spacingS,
    ),
  ),
  onPressed: () {},
  child: Text('Button'),
)
```

### Cards
```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  child: Padding(
    padding: EdgeInsets.all(spacingM),
    child: Column(
      children: [],
    ),
  ),
)
```

### Input Fields
```dart
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    labelText: 'Label',
    hintText: 'Hint',
  ),
)
```

## Icons

### Icon Set
- Material Icons
- Custom Icons (if any)

### Icon Sizes
```dart
static const double iconSizeXS = 16;
static const double iconSizeS = 24;
static const double iconSizeM = 32;
static const double iconSizeL = 48;
```

## Images

### Image Sizes
- Album Cover: 500x500
- Thumbnail: 100x100
- Profile Picture: 200x200

### Image Placeholders
```dart
static const String placeholderAlbum = 'assets/images/placeholder_album.png';
static const String placeholderProfile = 'assets/images/placeholder_profile.png';
```

## Animations

### Duration
```dart
static const Duration animationDurationShort = Duration(milliseconds: 200);
static const Duration animationDurationMedium = Duration(milliseconds: 300);
static const Duration animationDurationLong = Duration(milliseconds: 400);
```

### Curves
```dart
static const Curve animationCurve = Curves.easeInOut;
```

## Dark Mode

### Dark Theme Colors
```dart
static const Color darkBackground = Color(0xFF121212);
static const Color darkSurface = Color(0xFF1E1E1E);
static const Color darkPrimary = Color(0xFFBB86FC);
static const Color darkSecondary = Color(0xFF03DAC6);
```

## Accessibility

### Text Scale
```dart
static const double textScaleFactor = 1.0;
```

### Contrast Ratios
- Text: 4.5:1 minimum
- Large Text: 3:1 minimum
- UI Components: 3:1 minimum

## Responsive Design

### Breakpoints
```dart
static const double mobileBreakpoint = 600;
static const double tabletBreakpoint = 900;
static const double desktopBreakpoint = 1200;
```

### Layout
- Mobile: Single column
- Tablet: Two columns
- Desktop: Three columns

## Assets Management

### Image Assets
- Place in `assets/images/`
- Use appropriate compression
- Provide @2x and @3x versions

### Font Assets
- Place in `assets/fonts/`
- Include all weights
- Provide fallback fonts

## Design Tokens

### Usage
```dart
Theme.of(context).textTheme.headline1
Theme.of(context).colorScheme.primary
Theme.of(context).spacing.unit
```

### Customization
- Override in theme
- Use provider for dynamic changes
- Maintain consistency 