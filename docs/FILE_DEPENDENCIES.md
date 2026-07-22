# File Dependencies

## lib/core/app_exceptions.dart

No imports.

## lib/core/error_handler.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:firebase_auth/firebase_auth.dart';`
- `import 'app_exceptions.dart';`

## lib/core/router.dart

**Imports:**
- `import 'package:go_router/go_router.dart';`
- `import 'package:flutter/material.dart';`
- `import '../providers/auth_provider.dart';`
- `import '../screens/patient/splash_screen.dart';`
- `import '../screens/patient/login_screen.dart';`
- `import '../screens/patient/otp_verification_screen.dart';`
- `import '../screens/patient/registration_screen.dart';`
- `import '../screens/patient/home_screen.dart';`
- `import '../screens/patient/book_token_screen.dart';`
- `import '../screens/patient/booking_success_screen.dart';`
- `import '../screens/patient/live_queue_screen.dart';`
- `import '../screens/reception/dashboard_screen.dart';`
- `import '../screens/reception/queue_management_screen.dart';`
- `import '../screens/reception/patient_search_screen.dart';`
- `import '../models/appointment_model.dart';`
- `import '../screens/admin/admin_dashboard_screen.dart';`
- `import '../screens/admin/employee_management_screen.dart';`
- `import '../screens/admin/doctor_management_screen.dart';`
- `import '../screens/admin/reports_screen.dart';`
- `import '../screens/admin/clinic_settings_screen.dart';`
- `import '../screens/admin/holiday_management_screen.dart';`
- `import '../screens/admin/notification_center_screen.dart';`

## lib/core/theme.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:google_fonts/google_fonts.dart';`

## lib/firebase_options.dart

**Imports:**
- `import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;`
- `import 'package:flutter/foundation.dart'`

## lib/main.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import 'core/theme.dart';`
- `import 'core/router.dart';`
- `import 'providers/auth_provider.dart';`
- `import 'providers/patient_provider.dart';`
- `import 'providers/appointment_provider.dart';`
- `import 'providers/queue_provider.dart';`
- `import 'providers/doctor_provider.dart';`
- `import 'providers/employee_provider.dart';`
- `import 'providers/settings_provider.dart';`
- `import 'providers/notification_provider.dart';`
- `import 'providers/holiday_provider.dart';`
- `import 'package:firebase_core/firebase_core.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'firebase_options.dart';`
- `import 'core/error_handler.dart';`
- `import 'widgets/offline_banner.dart';`

## lib/models/appointment_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/models/clinic_settings_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/models/doctor_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/models/employee_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/models/holiday_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/models/notification_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/models/patient_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/models/queue_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`
- `import 'token_model.dart';`

## lib/models/token_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/models/user_model.dart

**Imports:**
- `import 'package:equatable/equatable.dart';`

## lib/providers/appointment_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/appointment_model.dart';`
- `import '../repositories/appointment_repository.dart';`
- `import '../core/error_handler.dart';`

## lib/providers/auth_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/user_model.dart';`
- `import '../repositories/auth_repository.dart';`
- `import '../core/error_handler.dart';`

## lib/providers/doctor_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/doctor_model.dart';`
- `import '../repositories/doctor_repository.dart';`
- `import '../core/error_handler.dart';`

## lib/providers/employee_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/employee_model.dart';`
- `import '../repositories/employee_repository.dart';`
- `import '../core/error_handler.dart';`

## lib/providers/holiday_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/holiday_model.dart';`
- `import '../repositories/holiday_repository.dart';`
- `import '../core/error_handler.dart';`

## lib/providers/notification_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/notification_model.dart';`
- `import '../repositories/notification_repository.dart';`
- `import '../core/error_handler.dart';`

## lib/providers/patient_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/patient_model.dart';`
- `import '../repositories/patient_repository.dart';`
- `import '../core/error_handler.dart';`

## lib/providers/queue_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/queue_model.dart';`
- `import '../models/token_model.dart';`
- `import '../repositories/queue_repository.dart';`
- `import 'notification_provider.dart';`
- `import 'package:uuid/uuid.dart';`
- `import '../core/error_handler.dart';`

## lib/providers/settings_provider.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../models/clinic_settings_model.dart';`
- `import '../repositories/settings_repository.dart';`
- `import '../core/error_handler.dart';`

## lib/repositories/appointment_repository.dart

**Imports:**
- `import '../models/appointment_model.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`

## lib/repositories/auth_repository.dart

**Imports:**
- `import '../models/user_model.dart';`
- `import 'package:firebase_auth/firebase_auth.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`

## lib/repositories/doctor_repository.dart

**Imports:**
- `import '../models/doctor_model.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`

## lib/repositories/employee_repository.dart

**Imports:**
- `import '../models/employee_model.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`

## lib/repositories/holiday_repository.dart

**Imports:**
- `import '../models/holiday_model.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`

## lib/repositories/notification_repository.dart

**Imports:**
- `import '../models/notification_model.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`

## lib/repositories/patient_repository.dart

**Imports:**
- `import '../models/patient_model.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`

## lib/repositories/queue_repository.dart

**Imports:**
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import '../models/queue_model.dart';`

## lib/repositories/settings_repository.dart

**Imports:**
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import '../models/clinic_settings_model.dart';`

## lib/screens/admin/admin_dashboard_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import 'package:fl_chart/fl_chart.dart';`
- `import '../../widgets/dashboard_layout.dart';`
- `import '../../providers/queue_provider.dart';`
- `import '../../providers/doctor_provider.dart';`
- `import '../../providers/employee_provider.dart';`

## lib/screens/admin/clinic_settings_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../widgets/dashboard_layout.dart';`
- `import '../../providers/settings_provider.dart';`
- `import '../../models/clinic_settings_model.dart';`

## lib/screens/admin/doctor_management_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../widgets/dashboard_layout.dart';`
- `import '../../providers/doctor_provider.dart';`
- `import '../../models/doctor_model.dart';`

## lib/screens/admin/employee_management_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../widgets/dashboard_layout.dart';`
- `import '../../providers/employee_provider.dart';`
- `import '../../models/employee_model.dart';`

## lib/screens/admin/holiday_management_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import 'package:intl/intl.dart';`
- `import '../../widgets/dashboard_layout.dart';`
- `import '../../providers/holiday_provider.dart';`
- `import '../../models/holiday_model.dart';`

## lib/screens/admin/notification_center_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../widgets/dashboard_layout.dart';`
- `import '../../providers/notification_provider.dart';`

## lib/screens/admin/reports_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../widgets/dashboard_layout.dart';`
- `import '../../providers/queue_provider.dart';`

## lib/screens/patient/booking_success_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import '../../models/appointment_model.dart';`

## lib/screens/patient/book_token_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../providers/auth_provider.dart';`
- `import '../../providers/appointment_provider.dart';`
- `import '../../providers/queue_provider.dart';`
- `import '../../models/appointment_model.dart';`
- `import '../../widgets/doctor_info_card.dart';`

## lib/screens/patient/home_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../providers/auth_provider.dart';`
- `import '../../providers/queue_provider.dart';`
- `import '../../widgets/navigation.dart';`
- `import '../../widgets/loading_skeleton.dart';`
- `import '../../widgets/doctor_info_card.dart';`

## lib/screens/patient/live_queue_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../providers/queue_provider.dart';`
- `import '../../providers/auth_provider.dart';`
- `import '../../models/queue_model.dart';`

## lib/screens/patient/login_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../providers/auth_provider.dart';`
- `import '../../widgets/buttons.dart';`
- `import '../../widgets/inputs.dart';`

## lib/screens/patient/otp_verification_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../providers/auth_provider.dart';`
- `import '../../widgets/buttons.dart';`
- `import '../../widgets/inputs.dart';`

## lib/screens/patient/registration_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../providers/auth_provider.dart';`

## lib/screens/patient/splash_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import 'dart:math' as math;`

## lib/screens/reception/dashboard_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../core/theme.dart';`
- `import '../../widgets/dashboard_layout.dart';`
- `import 'walk_in_dialog.dart';`
- `import '../../providers/queue_provider.dart';`
- `import '../../providers/notification_provider.dart';`
- `import '../../models/queue_model.dart';`
- `import '../../models/token_model.dart';`
- `import 'package:intl/intl.dart';`

## lib/screens/reception/patient_search_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../../widgets/dashboard_layout.dart';`

## lib/screens/reception/queue_management_screen.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../providers/queue_provider.dart';`
- `import '../../models/token_model.dart';`
- `import '../../models/queue_model.dart';`
- `import '../../widgets/dashboard_layout.dart';`

## lib/screens/reception/walk_in_dialog.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../providers/queue_provider.dart';`

## lib/services/connectivity_service.dart

**Imports:**
- `import 'dart:async';`
- `import 'package:connectivity_plus/connectivity_plus.dart';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:flutter/material.dart';`

## lib/services/notification_service.dart

**Imports:**
- `import 'package:firebase_messaging/firebase_messaging.dart';`
- `import 'package:flutter/foundation.dart';`

## lib/widgets/buttons.dart

**Imports:**
- `import 'package:flutter/material.dart';`

## lib/widgets/cards.dart

**Imports:**
- `import 'package:flutter/material.dart';`

## lib/widgets/dashboard_layout.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:go_router/go_router.dart';`
- `import 'package:provider/provider.dart';`
- `import '../core/theme.dart';`
- `import '../providers/auth_provider.dart';`
- `import '../screens/reception/walk_in_dialog.dart';`

## lib/widgets/dialogs.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'buttons.dart';`

## lib/widgets/doctor_info_card.dart

**Imports:**
- `import 'package:flutter/material.dart';`

## lib/widgets/empty_state.dart

**Imports:**
- `import 'package:flutter/material.dart';`

## lib/widgets/inputs.dart

**Imports:**
- `import 'package:flutter/material.dart';`

## lib/widgets/loading_skeleton.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import 'package:shimmer/shimmer.dart';`

## lib/widgets/navigation.dart

**Imports:**
- `import 'package:flutter/material.dart';`

## lib/widgets/offline_banner.dart

**Imports:**
- `import 'package:flutter/material.dart';`
- `import '../services/connectivity_service.dart';`

## lib/widgets/responsive_layout.dart

**Imports:**
- `import 'package:flutter/material.dart';`

## lib/widgets/utilities.dart

**Imports:**
- `import 'package:flutter/material.dart';`

