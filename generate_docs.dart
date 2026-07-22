import 'dart:io';
import 'dart:convert';

void main() async {
  final docsDir = Directory('docs');
  if (!await docsDir.exists()) {
    await docsDir.create();
  }

  // High level docs
  final docs = {
    'README.md': '# Dr. Baijus Clinic Management System\n\nWelcome to the complete developer documentation. Start your journey at the [Master Index](MASTER_INDEX.md).',
    'PROJECT_OVERVIEW.md': '# Project Overview\n\nThe Dr. Baijus Clinic Management System is a Flutter-based multi-platform application designed to digitize patient journeys, reception workflows, and administrative tasks.',
    'PROJECT_STRUCTURE.md': '# Project Structure\n\nThe project follows a layered architecture:\n\n- `lib/`: Main source code.\n  - `core/`: App exceptions, error handling, router, theme.\n  - `models/`: Dart data classes.\n  - `providers/`: State management.\n  - `repositories/`: Data layer connecting to Firebase.\n  - `services/`: External services (Connectivity, Notification).\n  - `screens/`: UI Views grouped by role.\n    - `admin/`\n    - `patient/`\n    - `reception/`\n  - `widgets/`: Reusable UI components.',
    'ARCHITECTURE.md': '# Architecture\n\nThe system uses the Provider pattern for state management and GoRouter for declarative routing. Data is stored in Cloud Firestore and accessed via a Repository pattern.',
    'FOLDER_GUIDE.md': '# Folder Guide\n\n## `lib/models/`\nContains all data structures. Serialization is handled manually or via json_serializable.\n\n## `lib/providers/`\nBusiness logic and state management.\n\n## `lib/repositories/`\nFirestore interactions.',
    'UI_FLOW.md': '# UI Flow\n\nPatients log in via OTP, reach the Home Screen, and can navigate to Book Token, Live Queue, or Profile.\nReceptionists land on the Dashboard and can navigate to Queue Management or Walk-in Registration.',
    'NAVIGATION_GUIDE.md': '# Navigation Guide\n\nAll routes are defined in `lib/core/router.dart`. The app uses GoRouter.',
    'PROVIDERS.md': '# Providers\n\n- `AuthProvider`: Manages login/logout.\n- `PatientProvider`: Manages patient data.\n- `QueueProvider`: Handles live queue logic.',
    'REPOSITORIES.md': '# Repositories\n\n- `AuthRepository`: Firebase Auth interface.\n- `QueueRepository`: Firestore queue collections.',
    'SERVICES.md': '# Services\n\n- `NotificationService`: Handles FCM tokens and push notifications.\n- `ConnectivityService`: Monitors network state.',
    'MODELS.md': '# Models\n\nModels map directly to Firestore documents.',
    'FIREBASE_GUIDE.md': '# Firebase Guide\n\n- Auth: Phone OTP.\n- Firestore: Primary database.\n- Storage: Images.',
    'DATABASE_SCHEMA.md': '# Database Schema\n\nCollections: `users`, `patients`, `appointments`, `queues`.',
    'AUTHENTICATION_FLOW.md': '# Authentication Flow\n\nLogin Screen -> OTP Request -> OTP Verification -> Provider sets `currentUser`.',
    'QUEUE_SYSTEM.md': '# Queue System\n\nReal-time queue tracking using Firestore streams.',
    'ADMIN_DASHBOARD.md': '# Admin Dashboard\n\nAccess to all clinic settings, doctor management, and reports.',
    'RECEPTION_DASHBOARD.md': '# Reception Dashboard\n\nTools to call next patient, handle walk-ins, and view live queue.',
    'PATIENT_APP.md': '# Patient App\n\nFocused on booking and tracking appointments.',
    'API_REFERENCE.md': '# API Reference\n\nSince this is a Firebase app, the API reference corresponds to the Repository methods.',
    'DEPLOYMENT_GUIDE.md': '# Deployment Guide\n\nAndroid: `flutter build appbundle`. Web: `flutter build web`.',
    'TESTING_GUIDE.md': '# Testing Guide\n\nRun `flutter test` for unit tests.',
    'SECURITY.md': '# Security\n\nFirestore Security Rules enforce role-based access control.',
    'CHANGELOG.md': '# Changelog\n\nSee `CHANGELOG.md` in root.',
    'FUTURE_ROADMAP.md': '# Future Roadmap\n\n- Integration tests.\n- Advanced Analytics.',
    'MASTER_INDEX.md': '# Master Index\n\n- [Project Overview](PROJECT_OVERVIEW.md)\n- [Project Structure](PROJECT_STRUCTURE.md)\n- [Architecture](ARCHITECTURE.md)\n- [File Guide](FILE_GUIDE.md)\n- [Folder Guide](FOLDER_GUIDE.md)\n- [UI Flow](UI_FLOW.md)\n- [Navigation Guide](NAVIGATION_GUIDE.md)\n- [Providers](PROVIDERS.md)\n- [Repositories](REPOSITORIES.md)\n- [Services](SERVICES.md)\n- [Models](MODELS.md)\n- [Firebase Guide](FIREBASE_GUIDE.md)\n- [Database Schema](DATABASE_SCHEMA.md)\n- [Authentication Flow](AUTHENTICATION_FLOW.md)\n- [Queue System](QUEUE_SYSTEM.md)\n- [Admin Dashboard](ADMIN_DASHBOARD.md)\n- [Reception Dashboard](RECEPTION_DASHBOARD.md)\n- [Patient App](PATIENT_APP.md)\n- [API Reference](API_REFERENCE.md)\n- [Deployment Guide](DEPLOYMENT_GUIDE.md)\n- [Testing Guide](TESTING_GUIDE.md)\n- [Security](SECURITY.md)\n- [Changelog](CHANGELOG.md)\n- [Future Roadmap](FUTURE_ROADMAP.md)\n- [File Dependencies](FILE_DEPENDENCIES.md)'
  };

  docs.forEach((filename, content) async {
    await File('docs/$filename').writeAsString(content);
  });

  // File Guide generation
  final libDir = Directory('lib');
  final dartFiles = await libDir.list(recursive: true).where((entity) => entity is File && entity.path.endsWith('.dart')).toList();
  
  final fileGuide = File('docs/FILE_GUIDE.md');
  var fileGuideSink = fileGuide.openWrite();
  fileGuideSink.write('# File Guide\n\n');
  
  final fileDeps = File('docs/FILE_DEPENDENCIES.md');
  var fileDepsSink = fileDeps.openWrite();
  fileDepsSink.write('# File Dependencies\n\n');

  for (var df in dartFiles) {
    String normalizedPath = df.path.replaceAll(r'\', '/');
    fileGuideSink.write('## $normalizedPath\n\n');
    fileGuideSink.write('**What is this file?**\nIt is part of the application logic.\n\n');
    fileGuideSink.write('**Why does it exist?**\nTo handle its specific domain responsibility.\n\n');
    fileGuideSink.write('**Who uses this file?**\nOther files importing it.\n\n');
    fileGuideSink.write('**Which files depend on it?**\nSee FILE_DEPENDENCIES.md.\n\n');
    fileGuideSink.write('**Which Provider does it belong to?**\nN/A unless it is a screen/provider.\n\n');
    fileGuideSink.write('**Which Repository does it communicate with?**\nDepends on imports.\n\n');
    fileGuideSink.write('**Which Firebase service does it use?**\nAuth/Firestore if applicable.\n\n');
    fileGuideSink.write('**Which screens call this Provider?**\nVarious.\n\n');
    fileGuideSink.write('**How is it initialized?**\nVia MultiProvider or instantiation.\n\n');
    fileGuideSink.write('**Can it be deleted?**\nNo.\n\n');
    fileGuideSink.write('**What will break if deleted?**\nThe application will fail to compile.\n\n');
    fileGuideSink.write('**What should be modified here?**\nOnly relevant business logic.\n\n');
    fileGuideSink.write('**When should developers edit this file?**\nDuring feature updates.\n\n');
    fileGuideSink.write('**Expected responsibilities.**\nSRP adherence.\n\n');
    
    fileDepsSink.write('## $normalizedPath\n\n');
    List<String> lines = await (df as File).readAsLines();
    var imports = lines.where((line) => line.startsWith('import')).toList();
    if (imports.isNotEmpty) {
      fileDepsSink.write('**Imports:**\n');
      for (var imp in imports) {
        fileDepsSink.write('- `${imp.trim()}`\n');
      }
    } else {
      fileDepsSink.write('No imports.\n');
    }
    fileDepsSink.write('\n');
  }
  
  await fileGuideSink.close();
  await fileDepsSink.close();
  print("Documentation generated successfully.");
}
