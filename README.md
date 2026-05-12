# NexCalc

A modern, beautiful calculator app built with Flutter using BLoC architecture.

## Features

- ✨ Clean and modern UI with dark theme
- ➕ Basic arithmetic operations (+, -, ×, ÷)
- 🔢 Decimal point support
- ⌫ Delete and clear functions
- 📱 Optimized for portrait mode
- 🎯 Real-time expression display
- ⚡ Built with BLoC for reactive state management
- 🎨 Material Design principles

## Screenshots

(Add your app screenshots here)

## Architecture

This app follows the BLoC (Business Logic Component) pattern:

```
lib/
├── bloc/
│   ├── calculator_bloc.dart    # Business logic
│   ├── calculator_event.dart   # Events
│   └── calculator_state.dart   # States
├── screens/
│   └── calculator_screen.dart  # Main calculator UI
├── widgets/
│   └── calculator_button.dart  # Reusable button widget
└── main.dart                    # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd nexcalc
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

## Play Store Deployment

See [PLAYSTORE_SETUP.md](PLAYSTORE_SETUP.md) for detailed instructions on:
- Generating signing keys
- Configuring release builds
- Publishing to Google Play Store

## Dependencies

- `flutter_bloc: ^8.1.6` - State management
- `equatable: ^2.0.5` - Value equality
- `math_expressions: ^2.6.0` - Expression evaluation

## Project Structure

### BLoC Pattern

**Events** (`calculator_event.dart`):
- `NumberPressed` - When a number button is pressed
- `OperatorPressed` - When an operator button is pressed
- `EqualsPressed` - When equals button is pressed
- `ClearPressed` - When clear button is pressed
- `DeletePressed` - When delete button is pressed
- `DecimalPressed` - When decimal point is pressed

**States** (`calculator_state.dart`):
- `CalculatorState` - Holds display value, expression, result, and error state

**BLoC** (`calculator_bloc.dart`):
- Handles all business logic
- Processes events and emits new states
- Evaluates mathematical expressions

## Testing

Run tests with:
```bash
flutter test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue in the repository
- Email: your-email@example.com

## Author

UK Solutions

## Acknowledgments

- Built with Flutter
- Uses BLoC pattern for state management
- Material Design guidelines

---

Made with ❤️ using Flutter

