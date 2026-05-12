# NexCalc - Play Store Deployment Guide

This guide will help you deploy the NexCalc calculator app to Google Play Store.

## Prerequisites

- Flutter SDK installed
- Android Studio or VS Code with Flutter extension
- Google Play Console account ($25 one-time registration fee)
- Java JDK installed (for signing)

## Step 1: Generate a Signing Key

You need to generate a signing key (keystore) to sign your app for release.

### On macOS/Linux:

```bash
keytool -genkey -v -keystore ~/nexcalc-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias nexcalc
```

### On Windows:

```bash
keytool -genkey -v -keystore %userprofile%\nexcalc-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias nexcalc
```

**Important:** 
- Keep this file secure and private
- Never commit it to version control
- Make a backup in a secure location
- Remember the passwords you set

The command will prompt you for:
- Keystore password (remember this!)
- Key password (remember this!)
- Your name, organization, city, state, and country

## Step 2: Create key.properties File

Create a file named `key.properties` in the `android/` directory (same level as `app/` folder):

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=nexcalc
storeFile=/path/to/nexcalc-key.jks
```

**Replace:**
- `YOUR_KEYSTORE_PASSWORD` with your keystore password
- `YOUR_KEY_PASSWORD` with your key password
- `/path/to/nexcalc-key.jks` with the actual path to your keystore file

**Example:**
```properties
storePassword=MySecurePass123
keyPassword=MySecurePass123
keyAlias=nexcalc
storeFile=/Users/username/nexcalc-key.jks
```

**Important:** Add `key.properties` to `.gitignore` to keep it private!

## Step 3: Update .gitignore

Add these lines to your `.gitignore` file:

```
# Android signing files
android/key.properties
*.jks
*.keystore
```

## Step 4: Build the Release APK/AAB

### Build App Bundle (AAB) - Recommended for Play Store

```bash
flutter build appbundle --release
```

The output file will be at:
`build/app/outputs/bundle/release/app-release.aab`

### Build APK (Alternative)

```bash
flutter build apk --release
```

The output file will be at:
`build/app/outputs/flutter-apk/app-release.apk`

**Note:** Google Play Store prefers AAB (App Bundle) format as it optimizes the app size for different devices.

## Step 5: Prepare Assets for Play Store

You'll need the following assets for Play Store listing:

### App Icon
- Already configured in the project
- Located at: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- You may want to create a custom icon using tools like:
  - [App Icon Generator](https://appicon.co/)
  - [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/)

### Screenshots
Take screenshots in these sizes:
- Phone: 1080 x 1920 pixels (minimum 2, maximum 8)
- 7-inch Tablet: 1536 x 2048 pixels (optional)
- 10-inch Tablet: 2048 x 2560 pixels (optional)

To take screenshots:
1. Run the app: `flutter run --release`
2. Use device/emulator screenshot feature
3. Or use: `flutter screenshot`

### Feature Graphic
- Size: 1024 x 500 pixels
- Required for Play Store listing
- Should showcase your app's main features

### App Description

**Short Description (80 characters max):**
"Simple, powerful calculator with advanced features. BLoC architecture."

**Full Description (4000 characters max):**
```
NexCalc - A Modern Calculator App

NexCalc is a beautiful and powerful calculator app designed with simplicity and functionality in mind.

Features:
✓ Clean, modern interface
✓ Basic arithmetic operations (+, -, ×, ÷)
✓ Decimal point support
✓ Delete and clear functions
✓ Real-time expression display
✓ Error handling
✓ Portrait mode optimized
✓ Dark theme for comfortable viewing

Perfect for:
- Quick calculations
- Daily math needs
- Students
- Professionals
- Anyone who needs a reliable calculator

Built with Flutter and BLoC architecture for smooth performance and reliability.

Download NexCalc today and simplify your calculations!
```

## Step 6: Create Play Console Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Sign in with your Google account
3. Pay the $25 one-time registration fee
4. Complete the account setup

## Step 7: Create Your App in Play Console

1. Click "Create app"
2. Fill in the details:
   - **App name:** NexCalc
   - **Default language:** English (United States)
   - **App or game:** App
   - **Free or paid:** Free
3. Accept declarations and click "Create app"

## Step 8: Complete Store Listing

Navigate through the left sidebar and complete:

### 1. Store Listing
- App name: NexCalc
- Short description: (use the one provided above)
- Full description: (use the one provided above)
- App icon: 512 x 512 PNG
- Feature graphic: 1024 x 500 JPG/PNG
- Screenshots: Upload phone screenshots
- App category: Tools
- Contact details: Your email
- Privacy policy: (optional for calculator apps)

### 2. Content Rating
- Fill out the questionnaire
- Calculators typically get "Everyone" rating

### 3. App Access
- Select "All functionality is available without restrictions"

### 4. Ads
- Select whether your app contains ads (currently: No)

### 5. Target Audience and Content
- Select age groups (13+ recommended)
- Complete the form

### 6. News Apps
- Select "No" (not a news app)

### 7. COVID-19 Contact Tracing
- Select "No"

### 8. Data Safety
- Complete the data safety form
- For a basic calculator: likely "No data collected"

## Step 9: Release Management

### 1. Select Release Track
Options:
- **Internal testing:** For your team (up to 100 testers)
- **Closed testing:** For a limited group of testers
- **Open testing:** Public beta
- **Production:** Public release

**Recommended:** Start with Internal or Closed testing

### 2. Create Release
1. Click "Create new release"
2. Upload your AAB file: `app-release.aab`
3. Review and confirm
4. Set release name: e.g., "1.0.0 - Initial Release"
5. Add release notes:

```
Initial release of NexCalc!

Features:
- Basic arithmetic operations
- Clean, modern interface
- Real-time calculations
- Dark theme
```

### 3. Review and Rollout
1. Review your release
2. Start rollout to selected track
3. Submit for review

## Step 10: App Review Process

- Google typically reviews apps within 1-3 days
- You'll receive an email when review is complete
- If approved, your app will be published
- If rejected, address the issues and resubmit

## Step 11: Promote to Production

Once testing is complete:
1. Go to your testing track
2. Select "Promote release"
3. Choose "Production"
4. Review and confirm
5. Your app will be live on Play Store!

## Updating Your App

To release an update:

1. **Update version in pubspec.yaml:**
   ```yaml
   version: 1.0.1+2  # Format: version+buildNumber
   ```

2. **Build new AAB:**
   ```bash
   flutter build appbundle --release
   ```

3. **Create new release in Play Console:**
   - Go to Production → Create new release
   - Upload new AAB
   - Add release notes
   - Roll out

## Troubleshooting

### Build Fails
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build appbundle --release
```

### Signing Issues
- Verify `key.properties` file exists in `android/` directory
- Check that all paths and passwords are correct
- Ensure keystore file exists at specified location

### Play Console Errors
- Ensure all required fields are filled
- Check that AAB is properly signed
- Verify version code is higher than previous releases

## Important Security Notes

⚠️ **Never commit these files to version control:**
- `key.properties`
- `*.jks` or `*.keystore` files
- Any files containing passwords

✅ **Do backup securely:**
- Your keystore file
- Your passwords (in a password manager)
- Without these, you cannot update your app!

## Support and Resources

- [Flutter Deployment Documentation](https://flutter.dev/docs/deployment/android)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

## App Information

- **Package Name:** com.uksolutions.nexcalc
- **App Name:** NexCalc
- **Current Version:** 1.0.0+1
- **Min SDK:** 21 (Android 5.0)
- **Target SDK:** Latest (configured automatically)

---

**Congratulations!** You're now ready to publish NexCalc to the Google Play Store! 🎉
