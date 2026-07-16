# Firebase Setup Guide

This guide details the steps to set up Firebase for the Dr. Baiju's Healthcare app.

## 1. Firebase Console Setup
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add project** and create a new project.
3. Enable **Google Analytics** during setup.
4. Enable the following services from the left sidebar:
   - **Authentication**: Enable Phone authentication.
   - **Firestore Database**: Create the database in production mode.
   - **Storage**: Set up Firebase Storage.
   - **Crashlytics**: Enable Crashlytics.
   - **Cloud Messaging (FCM)**: Ensure FCM is active for push notifications.

## 2. FlutterFire CLI Commands
Use the `flutterfire` CLI to auto-generate platform configurations.

```bash
# Install the Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Activate FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for the project (Run this in the project root)
flutterfire configure
```

## 3. Required Packages
The following packages have been added to `pubspec.yaml`:
- `firebase_core`: Core initialization.
- `firebase_auth`: For Phone OTP Auth.
- `cloud_firestore`: For NoSQL database operations.
- `firebase_storage`: For medical reports and images.
- `firebase_messaging`: For Push Notifications.
- `firebase_analytics`: For user behavior analytics.
- `firebase_crashlytics`: For error reporting.

## 4. Environment Configuration
Ensure you have the generated `firebase_options.dart` securely tracked or injected via CI/CD. Never commit raw API keys to public repositories if they don't have domain restrictions.

## 5. Android Setup
1. Go to `android/app/build.gradle`.
2. Ensure you have the `com.google.gms.google-services` plugin applied.
3. Add your SHA-1 and SHA-256 fingerprints in the Firebase Console (required for Phone Auth).

## 6. Web Setup
Web is automatically configured by `flutterfire configure`. Ensure you are running `flutter run -d chrome`.
