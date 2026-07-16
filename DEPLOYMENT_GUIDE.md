# Production Deployment Guide

This guide details the steps required to take the Dr. Baiju's Healthcare app to production with Firebase.

## 1. Firebase Project Readiness
Before deploying, ensure:
1. **Billing** is enabled (Blaze Plan) on your Firebase project if you expect higher limits or use certain extensions.
2. **Security Rules** (Firestore and Storage) are deployed using `firebase deploy --only firestore:rules,storage`.
3. **Indexes** are deployed using `firebase deploy --only firestore:indexes`.

## 2. App Signing (Android)
To use Firebase Phone Authentication in production on Android, you must provide your Release SHA-1 and SHA-256 keys to Firebase.
1. Generate a release keystore.
2. Add the signing config to `android/app/build.gradle`.
3. Run `./gradlew signingReport` or extract the SHA from Google Play Console (App Signing by Google Play).
4. Add these hashes to the Firebase Console -> Project Settings -> Android App.

## 3. APNs Configuration (iOS)
To use Firebase Phone Authentication and Cloud Messaging on iOS:
1. Generate an APNs auth key in the Apple Developer portal.
2. Upload the APNs key in the Firebase Console -> Project Settings -> Cloud Messaging.
3. Add the Push Notifications and Background Modes (Remote Notifications) capabilities in Xcode.
4. Ensure the `GoogleService-Info.plist` is correctly linked in Xcode.

## 4. Building the Application
Once Firebase is fully configured, build the application for release:

```bash
# Build Android AppBundle
flutter build appbundle --release

# Build iOS IPA (requires macOS)
flutter build ipa --release

# Build Web (if hosting on Firebase Hosting)
flutter build web --release
```

## 5. Web Hosting Deployment
If you are deploying the Receptionist/Admin panels to the web using Firebase Hosting:

1. Initialize Firebase Hosting:
   ```bash
   firebase init hosting
   ```
   *Set `build/web` as the public directory.*
   *Configure as a single-page app (rewrite all URLs to /index.html).*

2. Deploy:
   ```bash
   firebase deploy --only hosting
   ```
