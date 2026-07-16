# Known Limitations

This document lists the known limitations and constraints encountered during the final phase of development for Dr. Baiju's Healthcare App.

## Development Environment Constraints

### 1. Insufficient Disk Space
During the **Testing** phase (Step 2 of Phase 10), the environment encountered a critical failure:
```
OS Error: There is not enough space on the disk.
```
This error prevented:
- `build_runner` from generating mocks via `mockito`.
- `flutter test` from compiling the test files to `.dill` binary formats.
- Complete execution of the unit, widget, and integration testing suites.

**Impact:** Tests could not be fully implemented or executed. The `TEST_REPORT.md` is inherently incomplete because the automated validation steps cannot run on this machine until disk space is cleared.

### 2. Large File Architectural Debt
Several widget files exceed 250 lines (e.g., `queue_management_screen.dart`, `admin_dashboard_screen.dart`). While minor refactors (such as extracting `DoctorInfoCard`) were applied to mitigate this, further architectural decomposition requires a stable testing environment to prevent regression bugs.

### 3. Integration Testing
Full Integration testing mimicking real-world firestore instances was skipped due to the inability to generate mocks or run the compiler. 
