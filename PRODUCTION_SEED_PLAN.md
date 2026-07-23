# Production Seed Plan

This document details the exact Firestore documents and Firebase Auth accounts that have been created to initialize the production environment. 

> ✅ **Data has been seeded successfully.**

---

## 1. Firebase Authentication Accounts

Accounts were created manually via the Firebase Console to avoid storing plaintext passwords.

### Admin Account
- **Purpose**: Full clinic configuration and staff management access.
- **Provider**: Email / Password
- **Values**: 
  - Email: `nivedtthottiyil@gmail.com`
- **Status**: Seeded & Verified

### Receptionist Account
- **Purpose**: Managing daily queue, walk-ins, and marking patient arrivals.
- **Provider**: Email / Password
- **Values**:
  - Email: `baijushealthcare@gmail.com`
- **Status**: Seeded & Verified

---

## 2. Firestore Collections

### Collection: `users`
**Used by**: `AuthRepository`, `AuthProvider`, `firestore.rules` (Role validation)

#### Admin User Document
| Field | Type | Proposed Value | Status |
|-------|------|----------------|--------|
| `id` | String | `UkRMrdqDtcMjx3cpYv4NLOWl0Im1` | Seeded |
| `name` | String | Admin | Seeded |
| `email` | String | `nivedtthottiyil@gmail.com` | Seeded |
| `role` | String | `admin` | Seeded |

#### Reception User Document
| Field | Type | Proposed Value | Status |
|-------|------|----------------|--------|
| `id` | String | `KwtTt2yWrReZ0LIHzSeYElWCx5O2` | Seeded |
| `name` | String | Manojkumar | Seeded |
| `email` | String | `baijushealthcare@gmail.com` | Seeded |
| `role` | String | `reception` | Seeded |

---

### Collection: `settings`
**Used by**: `SettingsRepository`, `BookTokenScreen`, `BookingRepository`
**Document ID Strategy**: Singleton (`clinic_settings`)

#### Document: `settings/clinic_settings`
| Field | Type | Proposed Value | Status |
|-------|------|----------------|--------|
| `clinicName` | String | Dr. Baiju's Health Care | Seeded |
| `isQueueEnabled` | Boolean | `true` | Seeded |
| `isBookingOpen` | Boolean | `true` | Seeded |
| `averageConsultationTimeMinutes`| Number | `8` | Seeded |
| `address` | String | Manjeri, Meempara... | Seeded |
| `contactNumber` | String | 8281234866, 9074041115 | Seeded |
| `email` | String | `baijushealthcare@gmail.com` | Seeded |
| `openingTime` | String | `4:30 PM` | Seeded |
| `closingTime` | String | `7:30 PM` | Seeded |
| `consultationFee` | Number | `300` | Seeded |

*(Note: Maximum tokens per day and advance booking limits are deliberately omitted as per constraints. `maximumDailyPatients` will be omitted to avoid enforcing an unconfirmed limit.)*

---

### Collection: `doctors`
**Used by**: `DoctorInfoCard`, UI display
**Document ID Strategy**: Specific ID (e.g., `dr_baiju_mb`) mapped in code.

#### Document: `doctors/dr_baiju_mb`
| Field | Type | Proposed Value | Status |
|-------|------|----------------|--------|
| `id` | String | `dr_baiju_mb` | Confirmed |
| `name` | String | Dr. Baiju MB | Confirmed |
| `qualification` | String | MBBS, MD | Confirmed |
| `designation` | String | Physician & Diabetologist | Confirmed |
| `specialization` | String | General Medicine, Diabetology | Confirmed |
| `isAvailable` | Boolean | `true` | Confirmed |

---

### Collection: `employees`
**Used by**: Admin Dashboard
**Document ID Strategy**: Auto-ID

#### Document: `employees/<auto-id>`
| Field | Type | Proposed Value | Status |
|-------|------|----------------|--------|
| `userId` | String | `<Auth_UID>` | Confirmed (Post-Auth) |
| `name` | String | ⚠️ **MISSING** | Missing |
| `position` | String | Receptionist | Confirmed |
| `department` | String | Front Desk | Confirmed |
| `email` | String | ⚠️ **MISSING** | Missing |
| `isActive` | Boolean | `true` | Confirmed |

---

## 3. Storage & Initial Setup Requirements

- Firebase Storage is deferred. Profile images (`DoctorInfoCard`, patient avatars) fall back correctly to placeholder UI without needing a Storage bucket.
- No `holidays` documents are proposed yet (waiting for clinic input).
