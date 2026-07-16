# Final Release Checklist

This document serves as the final validation before submitting the application to production stores.

## Pre-Release Validations
- [x] **Code Quality:** Ensure 0 Analyzer warnings and resolution of all deprecations (`QUALITY_AUDIT.md`).
- [x] **Performance Optimization:** Implemented lazy loading, `const` optimizations, and robust offline banner caching (`PERFORMANCE_REPORT.md`).
- [ ] **Automated Testing:** All unit, widget, and integration tests must pass. *(Blocked due to Disk Space)*.
- [ ] **Security Review:** Firestore Rules must be updated in the Firebase Console (See Security & Rules section).

## App Metadata Configuration
- [x] **App Name:** Validated as `Dr. Baiju's Healthcare`.
- [x] **Package Name:** Default configuration (`com.example.baijus`) maintained as per user limitations; must be changed to `com.drbaijus.healthcare` before actual store deploy.
- [x] **Version Name / Code:** Set to `0.1.0+1` (See `pubspec.yaml`).
- [x] **Permissions:** Internet and Offline Network permissions inherently configured.

## Assets & Design
- [ ] **App Icon:** Generate and apply production icons via `flutter_launcher_icons`. (Skipped due to disk constraints).
- [ ] **Splash Screen:** Generate and apply production splash via `flutter_native_splash`. (Skipped due to disk constraints).

## Security & Rules (Action Required)
Ensure the following Firestore rules are deployed to your Firebase console prior to launch:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /appointments/{appointmentId} {
      allow read, create: if request.auth != null;
      allow update, delete: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'receptionist'];
    }
    match /queue/{queueId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'receptionist'];
    }
  }
}
```

## Approval Status
- **Ready for Merging:** **NO** (Pending disk space resolution and subsequent test execution).
