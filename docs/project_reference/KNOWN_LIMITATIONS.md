# Known Limitations & Cloud Functions Status

## Cloud Functions / FCM Status
Currently, Cloud Functions for Firebase are **NOT** deployed because the project is on the Spark (free) plan, which does not support Node.js backend execution environments.

Because Cloud Functions are missing, the following features are temporarily deferred:
- Server-triggered FCM (Firebase Cloud Messaging) push notifications for queue updates.
- Secure backend-triggered notifications for appointments (e.g., "5 patients remaining" push notifications).
- Server-side scheduled automations (like auto-closing the queue at midnight).

## Security Risk: `tokenCounters` Increment Vulnerability
Without Cloud Functions, the token increment logic relies on a client-side transaction (Phase 3). 
While the transaction guarantees **atomic sequencing** and duplicate-prevention via `bookingLocks`, an authenticated patient client *could* theoretically manipulate the transaction payload to artificially inflate the `tokenCounters` value.

### Impact Assessment
- **Token Sequencing**: A malicious client could skip token numbers (e.g., jump from 5 to 100), disrupting the visual queue numbering.
- **Queue Integrity**: The order of bookings would still be based on `bookingLocks` and timestamps, but the numerical tokens would have gaps.
- **Availability**: It would cause confusion in the clinic (UX disruption).
- **Authorization / Patient Data Security**: This **DOES NOT** affect authorization or expose any patient data. A patient cannot book on behalf of others, nor can they view other patients' data.

### Mitigation
This is classified as a **UX Disruption Vulnerability**. The ultimate fix is moving the token generation entirely to a trusted backend environment (Cloud Functions / Firebase Blaze Plan) so the client only submits a request, and the server generates and returns the token.
