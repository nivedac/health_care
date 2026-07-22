# Project Structure

The project follows a layered architecture:

- `lib/`: Main source code.
  - `core/`: App exceptions, error handling, router, theme.
  - `models/`: Dart data classes.
  - `providers/`: State management.
  - `repositories/`: Data layer connecting to Firebase.
  - `services/`: External services (Connectivity, Notification).
  - `screens/`: UI Views grouped by role.
    - `admin/`
    - `patient/`
    - `reception/`
  - `widgets/`: Reusable UI components.