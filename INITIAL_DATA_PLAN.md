# Initial Data Plan — Dr. Baiju's Healthcare

This document defines the exact production data that must be created in Firestore
**before the app goes live**. Nothing here has been seeded yet.

> ⚠️ **Do NOT seed this data until the Firestore rules and Authentication have been
> configured, reviewed, and approved.**

---

## 1. Firebase Authentication Accounts

### Admin Account
| Field | Value | Status |
|-------|-------|--------|
| Email | ⚠️ **MISSING — Please provide** | Required |
| Password | ⚠️ **MISSING — Please provide** | Required |
| Display Name | Admin | — |

### Receptionist Account(s)
| Field | Value | Status |
|-------|-------|--------|
| Email | ⚠️ **MISSING — Please provide** | Required |
| Password | ⚠️ **MISSING — Please provide** | Required |
| Display Name | ⚠️ **MISSING — Name of receptionist** | Required |

> **How to create**: Use Firebase Console → Authentication → Add user.  
> Then create matching `users/{uid}` documents in Firestore with the correct role.

---

## 2. Firestore: `users` Collection

### Admin User Document
```json
{
  "id": "<UID from Firebase Auth>",
  "name": "Admin",
  "email": "<admin email>",
  "role": "admin",
  "phoneNumber": "⚠️ MISSING",
  "profileImageUrl": null,
  "createdAt": "<server timestamp>",
  "fcmToken": null
}
```

### Receptionist User Document
```json
{
  "id": "<UID from Firebase Auth>",
  "name": "⚠️ MISSING — Receptionist name",
  "email": "<receptionist email>",
  "role": "reception",
  "phoneNumber": "⚠️ MISSING",
  "profileImageUrl": null,
  "createdAt": "<server timestamp>",
  "fcmToken": null
}
```

---

## 3. Firestore: `doctors` Collection

### Dr. Baiju MB — Primary Doctor
```json
{
  "id": "auto-generated",
  "name": "Dr. Baiju MB",
  "specialization": "General Medicine & Diabetology",
  "qualification": "MBBS, MD",
  "designation": "Physician & Diabetologist",
  "profileImageUrl": "⚠️ MISSING — Doctor profile photo URL",
  "isAvailable": true,
  "consultationFeeINR": "⚠️ MISSING — Consultation fee in INR",
  "averageConsultationTimeMinutes": 15,
  "createdAt": "<server timestamp>"
}
```

> **Note**: The `userId` field in `doctors` would be needed if the doctor also
> has a Firebase Auth account for a future doctor portal. For now it can be null
> since there is no doctor app.

---

## 4. Firestore: `settings` Collection

### Singleton Document — `settings/clinic_settings`
```json
{
  "clinicName": "Dr. Baiju's Healthcare",
  "address": "⚠️ MISSING — Full clinic address",
  "clinicAddress": "⚠️ MISSING — Full clinic address",
  "contactNumber": "⚠️ MISSING — Clinic phone number",
  "phoneNumber": "⚠️ MISSING — Clinic phone number",
  "email": "⚠️ MISSING — Clinic email address",
  "openingTime": "⚠️ MISSING — e.g. 09:00 AM",
  "closingTime": "⚠️ MISSING — e.g. 05:00 PM",
  "maxTokensPerDoctor": "⚠️ MISSING — e.g. 30 or 50",
  "maximumDailyPatients": "⚠️ MISSING — e.g. 40",
  "averageConsultationTimeMinutes": 15,
  "consultationFee": "⚠️ MISSING — Consultation fee in INR",
  "isQueueEnabled": true,
  "tokenPrefix": "⚠️ MISSING — e.g. null or 'B' for B001",
  "updatedAt": "<server timestamp>"
}
```

---

## 5. Firestore: `employees` Collection

### Receptionist Employee Record
```json
{
  "id": "auto-generated",
  "userId": "<UID from Firebase Auth — same as receptionist user>",
  "name": "⚠️ MISSING — Receptionist name",
  "position": "Receptionist",
  "department": "Front Desk",
  "email": "<receptionist email>",
  "phone": "⚠️ MISSING — Receptionist phone number",
  "profileImageUrl": null,
  "isActive": true,
  "joinedAt": "<server timestamp>"
}
```

---

## 6. Firestore: `holidays` Collection

> No holidays are known yet. Please provide a list of planned clinic holidays or
> regular weekly off days before seeding.

Example format:
```json
{
  "id": "auto-generated",
  "date": "<Firestore Timestamp>",
  "name": "⚠️ MISSING — e.g. 'Onam' or 'Sunday Closure'",
  "description": "⚠️ MISSING",
  "disableBooking": true,
  "createdAt": "<server timestamp>"
}
```

---

## 7. Missing Information — Summary Checklist

The following information is required from you before data can be seeded:

| # | Item | Status |
|---|------|--------|
| 1 | Admin email address | ⚠️ Missing |
| 2 | Admin password (initial) | ⚠️ Missing |
| 3 | Receptionist name(s) | ⚠️ Missing |
| 4 | Receptionist email(s) | ⚠️ Missing |
| 5 | Receptionist phone(s) | ⚠️ Missing |
| 6 | Clinic full address | ⚠️ Missing |
| 7 | Clinic contact phone number | ⚠️ Missing |
| 8 | Clinic email address | ⚠️ Missing |
| 9 | Clinic opening time | ⚠️ Missing |
| 10 | Clinic closing time | ⚠️ Missing |
| 11 | Maximum tokens per day | ⚠️ Missing |
| 12 | Consultation fee (INR) | ⚠️ Missing |
| 13 | Token prefix (e.g., null or 'B') | ⚠️ Missing |
| 14 | Doctor profile photo | ⚠️ Missing |
| 15 | Planned clinic holidays list | ⚠️ Missing |
| 16 | Admin phone number (optional) | ⚠️ Missing |

---

## 8. Data That Should NOT Be Seeded

- ❌ Patient records (self-registered via phone OTP)
- ❌ Appointment history (created when patients book)
- ❌ Queue records (auto-created daily at clinic open)
- ❌ Notification history (generated by the system/Cloud Functions)

---

## 9. Seeding Sequence (When Ready)

1. Create Firebase Auth accounts for Admin and Receptionist(s)
2. Seed `users` documents for Admin and Receptionist(s) with correct UIDs
3. Seed `doctors` document for Dr. Baiju MB
4. Seed `settings/clinic_settings` singleton
5. Seed `employees` document for Receptionist(s)
6. Seed `holidays` (if applicable)
7. Upload clinic logo to Firebase Storage at `clinic/logo.png`
8. Upload doctor photo to Firebase Storage at `doctors/{doctorId}/profile.jpg`
