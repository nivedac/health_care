# Production Smoke Test Checklist

Execute this checklist manually on real devices/browsers after deploying the final artifacts.

## Patient App (Android APK)
- [ ] Install fresh APK on a physical Android device.
- [ ] Enter valid phone number for OTP.
- [ ] Receive SMS via Firebase real OTP delivery.
- [ ] Verify OTP successfully.
- [ ] Complete patient profile creation (if new user).
- [ ] Verify session persistence across app restarts.
- [ ] View doctor profile and clinic details.
- [ ] Complete advance booking process.
- [ ] Verify that ₹300 consultation fee is displayed.
- [ ] Verify booking succeeds when `isBookingOpen = true`.
- [ ] Verify booking is BLOCKED when `isBookingOpen = false`.
- [ ] Verify token number is correctly generated and assigned.
- [ ] Attempt to book again on the same day -> verify DUPLICATE BOOKING PREVENTION blocks it.
- [ ] Cancel the appointment successfully.
- [ ] Rebook on the same day after cancellation -> verify it succeeds.
- [ ] Verify live queue display.
- [ ] Test offline behavior (app gracefully handles no internet).
- [ ] SECURITY: Verify patient cannot access `/admin` or `/reception` routes.

## Reception Portal (Web Dashboard)
- [ ] Navigate to Reception URL.
- [ ] Login using `baijushealthcare@gmail.com`.
- [ ] Verify correct reception dashboard loads.
- [ ] Verify NO admin-only options are visible or accessible.
- [ ] View list of patients.
- [ ] View today's appointments.
- [ ] Test Queue Management:
  - [ ] Start queue for the day.
  - [ ] Mark patient as `arrived`.
  - [ ] Mark patient as `inConsultation`.
  - [ ] Mark patient as `completed`.
  - [ ] Mark patient as `noShow`.
- [ ] Verify booking date scoping (Tomorrow's appointments do not appear in today's queue).

## Admin Portal (Web Dashboard)
- [ ] Navigate to Admin URL.
- [ ] Login using `nivedtthottiyil@gmail.com`.
- [ ] Verify correct admin dashboard loads.
- [ ] Manage Doctors (View Dr. Baiju M.B.).
- [ ] Manage Employees (View Manojkumar).
- [ ] Edit Clinic Settings.
- [ ] Toggle Booking Open/Close and verify effect on Patient App.
- [ ] Manage Holidays.

## Security Negative Tests
- [ ] Patient cannot access admin or reception routes.
- [ ] Reception cannot access admin-only functionality.
- [ ] Booking cannot occur when booking is closed.
- [ ] Duplicate active booking is rejected.
