# Development Setup Guide

## Prerequisites

### Required Software
1. **Flutter SDK**
   ```bash
   # Install Flutter SDK
   git clone https://github.com/flutter/flutter.git
   export PATH="$PATH:`pwd`/flutter/bin"
   flutter doctor
   ```

2. **Android Studio / VS Code**
   - Install Flutter and Dart plugins
   - Configure Android SDK
   - Set up iOS development environment

3. **Xcode (for iOS development)**
   - Install Xcode from App Store
   - Install CocoaPods
   ```bash
   sudo gem install cocoapods
   ```

4. **Git**
   ```bash
   # Install Git
   brew install git  # macOS
   ```

## Project Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/your-username/kolektt.git
   cd kolektt
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Configuration**
   ```bash
   # Copy environment file
   cp .env.example .env
   
   # Edit .env file with your API keys
   nano .env
   ```

4. **iOS Setup**
   ```bash
   cd ios
   pod install
   cd ..
   ```

5. **Android Setup**
   - Open Android Studio
   - Configure Android SDK
   - Set up Android emulator

## API Keys Setup

1. **Discogs API**
   - Register at [Discogs Developers](https://www.discogs.com/developers/)
   - Get API key and secret
   - Add to .env file:
     ```
     DISCOGS_KEY=your_key
     DISCOGS_SECRET=your_secret
     ```

2. **Supabase**
   - Create project at [Supabase](https://supabase.com)
   - Get project URL and anon key
   - Add to .env file:
     ```
     SUPABASE_URL=your_url
     SUPABASE_ANON_KEY=your_key
     ```

3. **Google ML Kit**
   - Set up Firebase project
   - Download google-services.json
   - Place in android/app/
   - Download GoogleService-Info.plist
   - Place in ios/Runner/

## Running the App

1. **Check Connected Devices**
   ```bash
   flutter devices
   ```

2. **Run on iOS**
   ```bash
   flutter run -d "iPhone"
   ```

3. **Run on Android**
   ```bash
   flutter run -d "Android"
   ```

## Common Issues

1. **iOS Build Issues**
   ```bash
   # Clean build
   cd ios
   pod deintegrate
   pod install
   cd ..
   flutter clean
   flutter pub get
   ```

2. **Android Build Issues**
   ```bash
   # Clean build
   flutter clean
   flutter pub get
   ```

3. **Environment Issues**
   - Check .env file exists
   - Verify API keys are correct
   - Check file permissions

## Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature
   ```

2. **Make Changes**
   - Follow coding standards
   - Write tests
   - Update documentation

3. **Test Changes**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: your feature description"
   ```

5. **Push Changes**
   ```bash
   git push origin feature/your-feature
   ```

## Debugging

1. **Flutter DevTools**
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

2. **Logging**
   - Use `debugPrint()` for debugging
   - Check console output
   - Use breakpoints in IDE

3. **Performance Profiling**
   ```bash
   flutter run --profile
   ```

## Testing

1. **Unit Tests**
   ```bash
   flutter test
   ```

2. **Widget Tests**
   ```bash
   flutter test test/widget_test.dart
   ```

3. **Integration Tests**
   ```bash
   flutter drive --target=test_driver/app.dart
   ```

## Documentation

1. **Generate Documentation**
   ```bash
   dartdoc
   ```

2. **Check Code Style**
   ```bash
   flutter analyze
   ```

3. **Format Code**
   ```bash
   flutter format .
   ``` 