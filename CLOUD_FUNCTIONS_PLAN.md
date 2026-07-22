# Cloud Functions Requirements Analysis

**Project**: Dr Baiju's Healthcare (`dr-baiju-s-healthcare`)  
**Status**: NOT IMPLEMENTED — Analysis only.  
**Decision required**: Upgrade to Blaze plan before implementation.

---

## Executive Summary

The app currently runs ALL logic on the client (Flutter app). This works for an 
initial launch with a small patient count, but several operations are **unsafe** 
or **unreliable** when done client-side. This document categorises each operation 
by its urgency and whether Cloud Functions are truly required.

---

## Blaze Plan Requirement

**Cloud Functions require the Firebase Blaze (pay-as-you-go) plan.**

The Spark (free) plan does NOT support Cloud Functions.

### Expected Blaze Costs for This Clinic

Cloud Functions pricing is based on invocations, compute time, and egress.
For a small clinic (10–50 patients/day):

| Resource | Free Tier (Blaze) | Expected Monthly Usage | Estimated Cost |
|----------|------------------|----------------------|----------------|
| Function invocations | 2M/month free | ~5,000–15,000/month | **₹0** |
| Compute time | 400K GB-sec/month free | ~5–15 GB-sec/month | **₹0** |
| Network egress | 5GB/month free | < 100MB/month | **₹0** |
| Firestore reads | 50K/day free | ~2,000–5,000/day | **₹0** |
| Firestore writes | 20K/day free | ~500–2,000/day | **₹0** |

**Conclusion: For this clinic's scale, Blaze plan will cost ₹0/month** (well within all 
free tiers). The Blaze plan requires a credit card on file but does NOT charge you 
unless usage exceeds the generous free quotas. At 10–50 patients/day, you will 
stay within free limits.

> **Recommendation: Upgrade to Blaze plan.** No actual billing will occur at this
> clinic's scale. It is required purely to unlock Cloud Functions.

---

## Operation Classification

### 🔴 CATEGORY 1 — CRITICAL: MUST be server-side (Cloud Functions)

These operations are **insecure or broken** if done purely client-side.

---

#### 1A. Atomic Token Number Assignment

**Current implementation** (`queue_provider.dart → generateToken()`):
```dart
final int nextTokenNum = _liveQueue!.activeTokens.length + 1;
```

**Problem**: Two patients booking simultaneously will:
1. Both read `activeTokens.length` as, say, 4
2. Both assign token number 5
3. Both write to Firestore — one overwrites the other
4. Result: **two patients with the same token number**

**Required solution**: Firestore atomic increment using a counter document:
```
queue/{queueId}/counters/tokenCounter → { count: N }
```
A Firestore transaction atomically increments `count` and returns the new value.
This CAN be done in Flutter via `runTransaction()` — **Cloud Functions not strictly required** for this specific operation, but Cloud Functions make it safer and auditable.

**Can do without Cloud Functions?** ✅ YES — using `FirebaseFirestore.instance.runTransaction()` with a counter subcollection. This is the recommended approach for the Spark plan.

---

#### 1B. Secure FCM Push Notifications

**Current implementation** (`notification_provider.dart → addMockNotification()`):
```dart
// Local mock only — no actual push notification sent
_notifications.insert(0, notification);
```

**Problem**: To send a real push notification to another user's device, you need their FCM token and you need to call the FCM API. You **cannot call the FCM API from a Flutter client** without exposing your server key.

**Required solution**: Cloud Function listens to Firestore writes or is triggered by HTTP call, then calls `admin.messaging().send()`.

**Can do without Cloud Functions?** ❌ NO — FCM server-side API cannot be called from the client. **This is the most critical Cloud Functions use case.**

---

### 🟡 CATEGORY 2 — IMPORTANT: Client-side is functional but has security gaps

---

#### 2A. Duplicate Booking Prevention

**Current implementation**: No server-side duplicate check. The UI shows a warning but doesn't prevent double-booking at the database level.

**Problem**: If a patient submits two simultaneous booking requests, both may succeed.

**Required solution using Firestore transaction (no Cloud Functions needed)**:
```dart
await FirebaseFirestore.instance.runTransaction((tx) async {
  final existing = await tx.get(existingBookingQuery); // check for existing
  if (existing.docs.isNotEmpty) throw Exception('Already booked');
  tx.set(newAppointmentRef, appointmentData);
});
```

**Can do without Cloud Functions?** ✅ YES — Firestore client-side transaction is sufficient for a small clinic. Cloud Functions provide better error handling and logging but are not required.

---

#### 2B. Appointment Status Transition Enforcement

**Current state**: A patient calling `cancelAppointment()` only sets `status = 'cancelled'`. There is no check that the appointment was actually in a `pending` or `confirmed` state — a patient could theoretically cancel a `completed` appointment.

**Can do without Cloud Functions?** ✅ YES — add a check in the repository before calling `.update()`. This is a client-side guard that is sufficient for a trusted clinic app.

---

### 🟢 CATEGORY 3 — NICE TO HAVE: Works fine client-side

---

#### 3A. Queue Daily Reset

**Need**: At midnight (or when reception opens the clinic), the previous day's queue should be archived and a fresh queue document created for today.

**Can do without Cloud Functions?** ✅ YES — Reception manually triggers "Open Clinic" from the dashboard, which creates the day's queue document. Scheduled daily reset via Cloud Functions is a convenience, not a security requirement.

---

#### 3B. "5 Patients Remaining" Notification

**Current implementation** (`queue_provider.dart → _checkRemainingPatients()`):
```dart
// Only works if the reception device is running the app at that moment
notifs?.addMockNotification(...)
```

**Problem**: Works only locally on the device that called `callNextPatient()`. Patients on other devices don't receive this.

**Required for real push**: Cloud Functions trigger (watch queue document changes).

**Can do without Cloud Functions?** ❌ NO — for real push to patient devices. ✅ YES — as an in-app counter shown in the live queue screen (patient pulls queue status manually).

---

#### 3C. Audit Logging / Analytics Events

**Nice to have**: Log every token assignment, queue advance, and appointment booking to a server-side audit trail.

**Can do without Cloud Functions?** ✅ YES — Firebase Analytics handles event tracking client-side. A Firestore `audit_log` collection can be written directly if needed.

---

## Summary Table

| Operation | Cloud Functions Required? | Spark Plan OK? | Priority |
|-----------|--------------------------|----------------|----------|
| Atomic token number | No (Firestore transaction) | ✅ | HIGH — implement now |
| Duplicate booking prevention | No (Firestore transaction) | ✅ | HIGH — implement now |
| FCM push notifications | **YES — mandatory** | ❌ Blaze required | HIGH — after Blaze upgrade |
| Status transition enforcement | No (repository guard) | ✅ | MEDIUM |
| Queue daily reset | No (manual from reception) | ✅ | LOW |
| "5 patients remaining" push | **YES — for real push** | ❌ Blaze required | LOW (in-app counter is fine) |
| Audit logging | No (Firestore write) | ✅ | LOW |

---

## Recommended Implementation Plan

### Phase 3A — Implement now (Spark plan, no billing)
1. **Atomic token counter** via Firestore transaction with `queue/{queueId}/counters/tokenCounter`
2. **Duplicate booking prevention** via Firestore transaction in `AppointmentRepository`
3. **Appointment status guard** in `AppointmentRepository.cancelAppointment()`

### Phase 3B — After Blaze plan upgrade
1. **FCM Cloud Function**: `onDocumentCreated('notifications/{id}')` → send push via FCM Admin SDK
2. **Queue change trigger**: `onDocumentUpdated('queue/{id}')` → check if ≤5 patients remaining → send push

### Phase 3C — Later / optional
1. Scheduled queue daily reset function
2. Audit log cloud function
3. Appointment reminder push (24h before appointment)

---

## Implications of Upgrading to Blaze

| Aspect | Impact |
|--------|--------|
| Cost | ₹0/month at this clinic's scale (within free quotas) |
| Requirement | Credit/debit card must be on file in Google Cloud |
| Billing control | Set a budget alert at ₹500/month to be notified if usage spikes |
| Risk | Essentially zero — free tier is very generous for small clinics |
| Unlock | Cloud Functions, Cloud Scheduler, Cloud Run |
| Recommended | **Yes — upgrade when ready to implement real push notifications** |

> **How to upgrade**: Firebase Console → Project Settings → Usage and billing → 
> Modify plan → Select Blaze (pay as you go) → Add billing method → Confirm.
