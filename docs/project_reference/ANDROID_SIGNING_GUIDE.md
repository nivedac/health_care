# Android Production Signing Guide

This document outlines the Android release signing process for Dr. Baiju's Health Care.

## What is the Upload/Release Keystore?
The `upload-keystore.jks` file is the cryptographic identity of this application. Google Play uses it to verify that the app was built and uploaded by you (or an authorized developer). It guarantees the integrity of updates.

## Why It Must NEVER Be Lost
If this keystore is lost, you **cannot** update the app on Google Play. Google Play requires every update to be signed with the same key. Losing the key means having to publish a brand-new app with a new package name, which causes all existing patients to lose access to updates and resets your app's download metrics and reviews.

> [!CAUTION]
> Losing signing credentials can create serious release/update problems.
> You must maintain at least two secure encrypted backups of the keystore and the password in separate trusted locations (e.g., a physical secure drive and a password manager vault).

## Keystore Details
- **Filename:** `upload-keystore.jks`
- **Alias Name:** `upload`
- **Location:** `android/app/upload-keystore.jks` (Locally generated)

> [!WARNING]
> DO NOT COMMIT THIS FILE TO GIT. It is already included in `.gitignore`.

## How `key.properties` Works
The `android/key.properties` file securely maps your keystore and password to the Android build system without hardcoding passwords in `build.gradle.kts`. 
Like the keystore, it must **never** be committed to version control.

The format is:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=upload-keystore.jks
```

## How Release Signing Works
In `android/app/build.gradle.kts`, the `release` build type is configured to strictly enforce the presence of `key.properties`. If a developer tries to build `flutter build apk --release` without `key.properties`, the build will intentionally crash with a `GradleException`. This prevents accidentally signing production builds with a debug key.

## How Future Developers Build Signed Artifacts
1. Ensure the new developer has access to the backup of `upload-keystore.jks`.
2. Place `upload-keystore.jks` in `android/app/`.
3. Create `android/key.properties` with the correct password.
4. Run `flutter build apk --release` or `flutter build appbundle --release`.

## How to Obtain SHA-1 / SHA-256 Later
If you ever need to view the SHA fingerprints again (e.g., for new Firebase configurations or Google Sign-in APIs), run the following command in the terminal:
```bash
keytool -list -v -keystore android/app/upload-keystore.jks -alias upload
```
You will be prompted to enter the keystore password.

## Google Play App Signing
When you upload the initial `.aab` file to Google Play, Google Play App Signing will be enabled by default. This means `upload-keystore.jks` acts strictly as an **Upload Key**. Google Play removes your upload signature and signs the final APK delivered to users with their own highly secure **App Signing Key**. 

> [!IMPORTANT]
> If Google Play App Signing is enabled, you MUST download the "App Signing Certificate SHA-1/SHA-256" from the Google Play Console (Release > Setup > App Integrity) and add it to your Firebase Console as well. Phone Auth will fail on production devices if the Google Play App Signing SHA is missing from Firebase.
