# Quick Start Guide

## 1. Install Dependencies

```bash
flutter pub get
```

## 2. Run the App (Development)

### On Android Emulator/Device
```bash
flutter run
```

### On Release Mode
```bash
flutter run --release
```

## 3. Build for Production

### Build AAB (App Bundle) for Play Store
```bash
# First, set up signing (see PLAYSTORE_SETUP.md)
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Build APK
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## 4. Test the App

```bash
flutter test
```

## 5. Check for Issues

```bash
flutter doctor
flutter analyze
```

## 6. Clean Build (if needed)

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

## Common Commands

| Command | Description |
|---------|-------------|
| `flutter run` | Run in debug mode |
| `flutter run --release` | Run in release mode |
| `flutter build apk` | Build release APK |
| `flutter build appbundle` | Build App Bundle |
| `flutter clean` | Clean build files |
| `flutter doctor` | Check Flutter setup |
| `flutter analyze` | Analyze code for issues |

## Troubleshooting

### Issue: Build fails
**Solution:** 
```bash
flutter clean
flutter pub get
```

### Issue: Dependencies not found
**Solution:**
```bash
flutter pub get
flutter pub upgrade
```

### Issue: Gradle build fails
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

## Next Steps

1. ✅ Install dependencies: `flutter pub get`
2. ✅ Run the app: `flutter run`
3. ✅ Test functionality
4. ✅ Follow PLAYSTORE_SETUP.md for Play Store deployment

Happy coding! 🚀
