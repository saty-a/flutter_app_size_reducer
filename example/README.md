# Flutter App Size Reducer Example

This example demonstrates how to use the `flutter_app_size_reducer` package in a Flutter application.

## Supported Platforms

- Android
- iOS
- Web
- Windows
- macOS
- Linux

## Running the Example

1. Make sure you have Flutter installed and set up for all platforms you want to test.
2. Run the following commands:

```bash
# For Android
dart run flutter_app_size_reducer -d android

# For iOS
dart run flutter_app_size_reducer -d ios

# For Web
dart run flutter_app_size_reducer -d chrome

# For Windows
dart run flutter_app_size_reducer -d windows

# For macOS
dart run flutter_app_size_reducer -d macos

# For Linux
dart run flutter_app_size_reducer -d linux
```

## Features Demonstrated

- Asset analysis
- Asset cleaning (with dry run)
- Asset optimization
- Configuration management

## Project Structure

```
example/
├── android/          # Android platform files
├── ios/             # iOS platform files
├── web/             # Web platform files
├── windows/         # Windows platform files
├── macos/           # macOS platform files
├── linux/           # Linux platform files
├── lib/             # Dart source code
├── assets/          # Example assets
│   ├── images/      # Example images
│   ├── icons/       # Example icons
│   └── fonts/       # Example fonts
└── pubspec.yaml     # Project configuration
```

## Configuration

The example includes a `flutter_app_size_reducer.yaml` configuration file that demonstrates how to configure the package for your project.
