# Firestore Security Rules — Explained

**Project**: Dr Baiju's Healthcare (`dr-baiju-s-healthcare`)  
**File**: `firestore.rules`  
**Last validated**: 2026-07-22  
**Validated against**: All 9 repository files in `lib/repositories/`

---

## Architecture Principle

> **The role of every user is ALWAYS read from the trusted Firestore `users/{uid}` 
> document on the server. The client never supplies or controls their own role.**

This means:
- A patient who guesses `/admin` in the URL is still blocked at the database level.
- A patient cannot promote themselves by changing a field in their own document.
- Staff accounts cannot be created from the patient app — only via Firebase Console or a trusted admin Cloud Function.

---

## Role Definitions

| Role | Who | Set By |
|------|-----|--------|
| `patient` | People who book appointments | Hardcoded on first OTP login |
| `reception` | Front desk staff | Admin via Firebase Console |
| `admin` | Clinic owner / manager | Admin via Firebase Console |
| `doctor` | (Future) Doctor portal user | Admin via Firebase Console |

---

## Helper Functions

### `isAuthenticated()`
Returns `true` if there is a signed-in Firebase Auth user. Used as the baseline gate before any data access.

### `isOwner(uid)`
Returns `true` if `request.auth.uid == uid`. Used to restrict a user to their own document only.

### `getUserRole()`
Reads the `role` field from `users/{request.auth.uid}` in Firestore. This is the core of the RBAC system — the role is never trusted from the incoming request data.

### `isAdmin()` / `isReception()` / `isStaff()`
Convenience wrappers that call `getUserRole()` and compare to the expected value. `isStaff()` returns `true` for `admin`, `reception`, or `doctor`.

### `roleIsUnchanged()`
Used on user document updates. Returns `true` if the request body does not include a `role` field, or if the role field is identical to what already exists. **Prevents privilege escalation.**

### `newUserIsPatient()`
Used on user document creation. Returns `true` only if `role == 'patient'`. **Prevents a new sign-up from ever being anything other than a patient.**

---

## Collection-by-Collection Permissions

---

### `users/{userId}`
*Stores: auth profile, role, FCM token, phone number.*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read own document | Owner | Patient reads their own profile |
| Read any document | Staff | Reception looks up a patient |
| Create | Owner, role must = `'patient'` | First patient login creates their record |
| Update own | Owner (role immutable) | Update FCM token, display name |
| Update any | Admin | Deactivate account, etc. |
| Delete | Admin | Account removal |

**Validated repository calls:**
- `auth_repository.dart → _fetchUserFromFirestore()`: `.doc(uid).get()` — own read ✅
- `auth_repository.dart → _fetchOrCreatePatientRecord()`: `.doc(uid).set()` — create own as patient ✅
- `auth_repository.dart → _persistFcmToken()`: `.doc(uid).update({fcmToken})` — update own (role unchanged) ✅

---

### `patients/{patientId}`
*Stores: extended health profile (DOB, blood group, gender, address).*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read own | Owner (userId match) | Patient reads their own health data |
| Read all | Staff | Reception searches/views patients |
| Create | Owner OR Reception/Admin | Self-registration or walk-in |
| Update own | Owner | Patient edits their own profile |
| Update any | Reception/Admin | Staff updates health notes |
| Delete | Admin | Patient data deletion |

**Validated repository calls:**
- `patient_repository.dart → getPatients()`: `.collection.get()` — full list, staff only ✅
- `patient_repository.dart → getPatientById()`: `.doc(id).get()` — own or staff ✅
- `patient_repository.dart → addPatient()`: `.collection.add()` — own userId or reception ✅

> **Note**: `getPatients()` does a full collection scan. If called by a patient, it
> will fail silently — the patient UI never calls this method (it only uses 
> `getPatientById()` with the patient's own UID). This is correct behaviour.

---

### `doctors/{doctorId}`
*Stores: doctor name, specialization, availability, consultation fee.*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read all / Read one | Any authenticated user | Patients browse doctors when booking |
| Create / Update / Delete | Admin only | Doctor profiles are clinic-managed |

**Validated repository calls:**
- `doctor_repository.dart → getDoctors()`: `.collection.get()` — any auth ✅
- `doctor_repository.dart → getDoctorById()`: `.doc(id).get()` — any auth ✅
- `doctor_repository.dart → addDoctor()`: `.collection.add()` — admin only ✅
- `doctor_repository.dart → updateDoctor()`: `.doc(id).update()` — admin only ✅
- `doctor_repository.dart → deactivateDoctor()`: `.doc(id).update(isAvailable)` — admin only ✅
- `doctor_repository.dart → deleteDoctor()`: `.doc(id).delete()` — admin only ✅

---

### `appointments/{appointmentId}`
*Stores: patientId, doctorId, appointmentDate (Timestamp), status, tokenNumber.*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read own | `patientId == auth.uid` | Patient sees their own appointments |
| Read all | Staff | Reception/admin dashboard |
| Create (own) | Patient (patientId must = own UID) | Patient self-booking |
| Create (any) | Reception/Admin | Walk-in or phone booking |
| Update own | Patient | Patient cancels their appointment |
| Update any | Staff | Reception reschedules, marks complete |
| Delete | Admin only | Hard deletion |

**Validated repository calls:**
- `appointment_repository.dart → getAppointments()`: `.collection.get()` — staff only ✅
- `appointment_repository.dart → getAppointmentsByPatientId()`: `.where('patientId')` — own ✅
- `appointment_repository.dart → bookAppointment()`: `.collection.add()` — own patientId ✅
- `appointment_repository.dart → cancelAppointment()`: `.doc(id).update(status)` — own or staff ✅

> **⚠️ Known limitation (Phase 3)**: A patient can set `status` to any value (e.g., 
> `'completed'`) when updating their own appointment. Proper status transition 
> enforcement requires Cloud Functions. This is a known gap, not a security risk 
> for the initial launch, as the UI doesn't expose this ability.

---

### `queue/{queueId}`
*Stores: doctorId, date, currentToken (Map), activeTokens (Array of Maps).*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read | Any authenticated user | Patients view queue position and wait time |
| Create | Staff only | Reception opens the daily queue |
| Update | Staff only | Reception calls next patient, marks arrived |

**Validated repository calls:**
- `queue_repository.dart → getLiveQueue()`: `.where('doctorId').limit(1).get()` — any auth (read) ✅
- `queue_repository.dart → getLiveQueue()`: `.collection.add(newQueue)` — staff only (create) ✅
- `queue_repository.dart → nextPatient()`: `runTransaction() → update` — staff only ✅

> **Note**: The Firestore rules correctly separate read (any auth) from write (staff only).
> The `getLiveQueue()` method both reads AND potentially creates a queue document.
> Creating requires a staff login — this is correct, as only reception opens the clinic.

---

### `settings/clinic_settings`
*Singleton document. Stores: clinic name, address, hours, max tokens, consultation fee.*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read | Any authenticated user | Booking screen checks opening hours, token limits |
| Write (create/update) | Admin only | Clinic configuration is admin-managed |

**Validated repository calls:**
- `settings_repository.dart → getSettings()`: `.doc('clinic_settings').get()` — any auth ✅
- `settings_repository.dart → updateSettings()`: `.doc('clinic_settings').set()` — admin only ✅

> **Note**: `getSettings()` also calls `.set(defaultSettings)` if the document doesn't 
> exist (first-run fallback). This `.set()` on a non-existent document is a **create** 
> operation. Currently, any authenticated user would be blocked from creating this 
> document. **Production fix**: Seed the `clinic_settings` document during initial data 
> seeding before any user accesses the app. The fallback will never be triggered.

---

### `employees/{employeeId}`
*Stores: name, position, department, email, phone, isActive, userId.*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read | Staff only | Patient app never shows employee data |
| Create / Update / Delete | Admin only | Employee management is admin-only |

**Validated repository calls:**
- `employee_repository.dart → getEmployees()`: `.collection.get()` — staff ✅
- `employee_repository.dart → getEmployeeById()`: `.doc(id).get()` — staff ✅
- `employee_repository.dart → addEmployee()`: `.collection.add()` — admin ✅
- `employee_repository.dart → updateEmployee()`: `.doc(id).update()` — admin ✅
- `employee_repository.dart → activateEmployee()`: `.doc(id).update(isActive)` — admin ✅
- `employee_repository.dart → deleteEmployee()`: `.doc(id).delete()` — admin ✅

---

### `holidays/{holidayId}`
*Stores: date (Timestamp), name, description, disableBooking.*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read | Any authenticated user | Booking calendar blocks holiday dates |
| Create / Update / Delete | Admin only | Holiday management is admin function |

**Validated repository calls:**
- `holiday_repository.dart → getHolidays()`: `.collection.get()` — any auth ✅
- `holiday_repository.dart → addHoliday()`: `.collection.add()` — admin ✅
- `holiday_repository.dart → updateHoliday()`: `.doc(id).update()` — admin ✅
- `holiday_repository.dart → deleteHoliday()`: `.doc(id).delete()` — admin ✅

---

### `notifications/{notificationId}`
*Stores: userId, title, message, timestamp (Timestamp), isRead.*

| Operation | Who Can Do It | Why |
|-----------|---------------|-----|
| Read | Owner (`userId == auth.uid`) | User reads their own notifications |
| Create | Staff | Reception sends alerts to patients |
| Update | Owner, `isRead` field only | Mark notification as read |
| Delete | Owner OR Admin | User clears inbox, admin purges |

**Validated repository calls:**
- `notification_repository.dart → getNotifications()`: `.where('userId').orderBy('timestamp')` — own ✅
- `notification_repository.dart → markAsRead()`: `.doc(id).update({isRead: true})` — own ✅
- `notification_repository.dart → createNotification()`: `.collection.add()` — staff ✅

> **Required index**: `(userId ASC, timestamp DESC)` — defined in `firestore.indexes.json`.
> Without this index, `getNotifications()` will throw an error in production.

---

## Known Gaps and Future Work

| Gap | Severity | Resolution |
|-----|----------|-----------|
| Patient can set any `status` value on their own appointment | Low | Cloud Function status transition validation (Phase 3) |
| `getSettings()` fallback creates document (any auth would be blocked) | None (by design) | Seed `clinic_settings` before launch; fallback never triggers |
| Queue document creation requires staff | By design | Reception creates queue on clinic open; patients only read |
| No rate limiting on OTP requests | Medium | Firebase Phone Auth has built-in quota limits |
| Notification `create` allows any staff (not just admin) | Acceptable | Reception needs to send patient alerts |

---

## Firestore Indexes (firestore.indexes.json)

Only **one compound index** is required by the current codebase:

| Collection | Fields | Order | Required By |
|------------|--------|-------|-------------|
| `notifications` | `userId` ASC, `timestamp` DESC | Compound | `notification_repository.dart → getNotifications()` |

All other queries use single-field filters (single-field indexes are auto-created by Firestore) or document-by-ID lookups (no index needed).

> **Why were the other indexes removed?**  
> The previous `firestore.indexes.json` included 7 compound indexes, but most were 
> for queries that are not yet implemented in the codebase 
> (e.g., `appointments by doctorId+date+status`, `queue by doctorId+date`). 
> Deploying unnecessary indexes wastes storage quota and adds confusion. They will be 
> added in Phase 3 alongside Cloud Functions when the queries that need them are built.
