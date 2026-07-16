# Architecture Overview

The Clinic Management System is a Flutter-based multi-platform application supporting Android and Web.

## Presentation Layer
- **State Management**: Built primarily using the `provider` package.
- **Routing**: Managed using the `go_router` package for robust, URL-driven navigation.
- **UI Components**: Follows Material Design guidelines. Reusable widgets are located in `lib/widgets/`.

## Business Logic & Data Layer
- **Repositories**: Abstract away data source interactions (e.g., `AuthRepository`, `DoctorRepository`, `QueueRepository`).
- **Models**: Strongly typed Dart models (e.g., `UserModel`, `PatientModel`) serialize and deserialize data from Firestore.
- **Providers**: Expose state and business logic to the UI layer (e.g., `AuthProvider`, `SettingsProvider`).

## Backend (Firebase)
- **Authentication**: Phone Number Auth (OTP).
- **Database**: Cloud Firestore.
- **Storage**: Firebase Cloud Storage.
- **Messaging**: Firebase Cloud Messaging (FCM).

## Security
- Firestore Security Rules restrict access based on roles (`patient`, `reception`, `admin`).
