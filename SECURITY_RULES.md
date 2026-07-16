# Firestore Security Rules

To enforce role-based access control, apply these rules in your Firebase Console (Firestore Database -> Rules).

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
  
    // Function to check user roles
    function isRole(role) {
      return request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == role;
    }
    
    // Function to check if the user is a receptionist or admin
    function isStaff() {
      return isRole('reception') || isRole('admin') || isRole('doctor');
    }

    match /users/{userId} {
      // Users can read and write their own data. Admins have full access.
      allow read: if request.auth != null && (request.auth.uid == userId || isStaff());
      allow write: if request.auth != null && (request.auth.uid == userId || isRole('admin'));
    }

    match /patients/{patientId} {
      // Patients can only read/write their own profile. Staff can access all.
      allow read: if request.auth != null && (resource.data.userId == request.auth.uid || isStaff());
      allow write: if request.auth != null && (request.resource.data.userId == request.auth.uid || isRole('admin') || isRole('reception'));
    }

    match /appointments/{appointmentId} {
      // Patients can only read/write their own appointments. Staff can access all.
      allow read: if request.auth != null && (resource.data.patientId == request.auth.uid || isStaff());
      allow write: if request.auth != null && (request.resource.data.patientId == request.auth.uid || isStaff());
    }

    match /queue/{queueId} {
      // Anyone logged in can view the queue (to see their turn).
      // Only staff can modify the queue.
      allow read: if request.auth != null;
      allow write: if isStaff();
    }

    match /settings/{docId} {
      // Anyone logged in can read settings. Only admins can write.
      allow read: if request.auth != null;
      allow write: if isRole('admin');
    }
    
    match /doctors/{doctorId} {
      allow read: if request.auth != null;
      allow write: if isRole('admin');
    }

    match /employees/{employeeId} {
      allow read: if isStaff();
      allow write: if isRole('admin');
    }

    match /holidays/{holidayId} {
      allow read: if request.auth != null;
      allow write: if isRole('admin') || isRole('reception');
    }

    match /notifications/{notificationId} {
      // Users can only read/write their own notifications.
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

## Required Firestore Indexes
The following compound indexes are required to support queries (e.g., getting appointments ordered by date). You can define these in a `firestore.indexes.json` file or create them manually via the Firebase Console:

```json
{
  "indexes": [
    {
      "collectionGroup": "notifications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "timestamp", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "appointments",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "patientId", "order": "ASCENDING" },
        { "fieldPath": "appointmentDate", "order": "DESCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
```
