# Firestore Database Schema

## 1. Collections and Fields

### `users`
Represents authentication profiles and roles.
- `id` (String, Document ID)
- `name` (String)
- `email` (String)
- `role` (String) - 'patient', 'reception', 'admin', 'doctor'
- `profileImageUrl` (String, Optional)
- `phoneNumber` (String, Optional)

### `patients`
- `id` (String, Document ID)
- `userId` (String) - Reference to `users.id`
- `phoneNumber` (String)
- `dateOfBirth` (Timestamp)
- `gender` (String)
- `bloodGroup` (String)

### `doctors`
- `id` (String, Document ID)
- `userId` (String) - Reference to `users.id`
- `name` (String)
- `specialization` (String)
- `isAvailable` (Boolean)

### `appointments`
- `id` (String, Document ID)
- `patientId` (String)
- `doctorId` (String)
- `appointmentDate` (Timestamp)
- `status` (String) - 'pending', 'completed', 'cancelled'

### `queue`
- `id` (String, Document ID)
- `doctorId` (String)
- `date` (Timestamp)
- `currentToken` (Map)
- `activeTokens` (Array of Maps)

### `employees`
- `id` (String, Document ID)
- `userId` (String)
- `name` (String)
- `position` (String)
- `department` (String)
- `isActive` (Boolean)

### `settings`
- Document ID: `clinic_settings` (Singleton)
- `clinicName` (String)
- `address` (String)
- `contactNumber` (String)
- `email` (String)
- `maxTokensPerDoctor` (Number)
- `openingTime` (String)
- `closingTime` (String)

### `holidays`
- `id` (String, Document ID)
- `date` (Timestamp)
- `name` (String)
- `description` (String)
- `disableBooking` (Boolean)

### `notifications`
- `id` (String, Document ID)
- `userId` (String)
- `title` (String)
- `message` (String)
- `timestamp` (Timestamp)
- `isRead` (Boolean)

## 2. Storage Folder Structure
Firebase Storage will be used to host media files. The structure is:
- `/clinic_assets/logo.png` - Clinic Logo
- `/doctors/{doctorId}/profile.jpg` - Doctor Images
- `/patients/{patientId}/profile.jpg` - Patient Profile Photos
- `/patients/{patientId}/prescriptions/{appointmentId}.pdf` - Future Prescription PDFs
- `/patients/{patientId}/reports/{reportId}.pdf` - Future Medical Reports
