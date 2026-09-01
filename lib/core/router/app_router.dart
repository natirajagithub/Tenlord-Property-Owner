import 'package:dormly_owner_mobile/ui/views/property_dashboard_screen.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/repository_provider.dart';
import '../../ui/view_models/owner_auth_view_model.dart';
import '../../ui/view_models/owner_dashboard_view_model.dart';
import '../../ui/view_models/properties_view_model.dart';
import '../../ui/view_models/tenants_view_model.dart';
import '../../ui/view_models/rent_ledger_view_model.dart';
import '../../ui/view_models/complaints_manage_view_model.dart';
import '../../ui/views/splash/splash_screen.dart';
import '../../ui/views/auth/owner_login_screen.dart';
import '../../ui/views/auth/owner_signup_screen.dart';
import '../../ui/views/auth/owner_verify_otp_screen.dart';
import '../../ui/views/properties/properties_tab.dart';
import '../../ui/views/properties/add_property_screen.dart';
import '../../ui/views/properties/property_unit_details_screen.dart';
import '../../ui/views/tenants/tenants_tab.dart';
import '../../ui/views/tenants/add_tenant_wizard_screen.dart';
import '../../ui/views/ledger/rent_ledger_tab.dart';
import '../../ui/views/complaints/complaints_manage_tab.dart';
import '../../ui/views/profile/owner_profile_tab.dart';
import '../../ui/views/notifications/notification_list_screen.dart';
import '../../ui/views/notifications/notification_details_screen.dart';
import '../../ui/views/tenants/tenant_details_screen.dart';
import '../../ui/views/ledger/collect_rent_sheet.dart';
import '../../ui/views/ledger/pending_rent_details_screen.dart';
import '../../ui/views/ledger/pending_rent_overview_screen.dart';
import '../../ui/views/ledger/overdue_rent_screen.dart';
import '../../ui/views/ledger/due_soon_screen.dart';
import '../../ui/views/profile/edit_profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String verifyOtp = '/verify-otp';
  static const String dashboard = '/dashboard';
  static const String rooms = '/rooms';
  static const String addProperty = '/add-property';
  static const String propertyUnits = '/property-units';
  static const String tenants = '/tenants';
  static const String addTenant = '/add-tenant';
  static const String ledger = '/ledger';
  static const String complaints = '/complaints';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String notificationDetails = '/notification-details';
  static const String tenantDetails = '/tenant-details';
  static const String pendingRentDetails = '/pending-rent-details';
  static const String recordPayment = '/record-payment';
  static const String pendingRentOverview = '/pending-rent-overview';
  static const String overdueRent = '/overdue-rent';
  static const String dueSoon = '/due-soon';
  static const String editProfile = '/edit-profile';
}

class AppRouter {
  static final repo = RepositoryProvider.ownerRepository;

  static final OwnerDashboardViewModel dashboardViewModel =
      OwnerDashboardViewModel(repository: repo)..loadDashboard();
  static final PropertiesViewModel propertiesViewModel = PropertiesViewModel(
    repository: repo,
  )..loadProperties();
  static final TenantsViewModel tenantsViewModel = TenantsViewModel(
    repository: repo,
  )..loadTenants();
  static final RentLedgerViewModel ledgerViewModel = RentLedgerViewModel(
    repository: repo,
  )..loadLedger();
  static final ComplaintsManageViewModel complaintsViewModel =
      ComplaintsManageViewModel(repository: repo)..loadComplaintsAndStaff();
  static final OwnerAuthViewModel authViewModel = OwnerAuthViewModel(
    repository: repo,
  );

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            OwnerLoginScreen(authViewModel: authViewModel),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) =>
            OwnerSignUpScreen(authViewModel: authViewModel),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) {
          final phone = state.extra as String? ?? '9876500000';
          return OwnerVerifyOtpScreen(
            phoneNumber: phone,
            authViewModel: authViewModel,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => OwnerMainNavigationScreen(
          dashboardViewModel: dashboardViewModel,
          tenantsViewModel: tenantsViewModel,
          ledgerViewModel: ledgerViewModel,
          complaintsViewModel: complaintsViewModel,
          propertiesViewModel: propertiesViewModel,
          authViewModel: authViewModel,
        ),
      ),
      GoRoute(
        path: AppRoutes.rooms,
        builder: (context, state) =>
            PropertiesScreen(viewModel: propertiesViewModel),
      ),
      GoRoute(
        path: AppRoutes.addProperty,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return AddPropertyScreen(initialData: data);
        },
      ),
      GoRoute(
        path: AppRoutes.propertyUnits,
        builder: (context, state) {
          String name = 'Skyline Luxury PG 01';
          if (state.extra is String) {
            name = state.extra as String;
          } else if (state.extra is Map) {
            final map = state.extra as Map;
            name = map['propertyName']?.toString() ?? name;
          }
          return PropertyUnitDetailsScreen(
            viewModel: propertiesViewModel,
            propertyName: name,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.tenants,
        builder: (context, state) => TenantsScreen(viewModel: tenantsViewModel),
      ),
      GoRoute(
        path: AppRoutes.addTenant,
        builder: (context, state) =>
            AddTenantWizardScreen(viewModel: tenantsViewModel),
      ),
      GoRoute(
        path: AppRoutes.ledger,
        builder: (context, state) =>
            RentLedgerScreen(viewModel: ledgerViewModel),
      ),
      GoRoute(
        path: AppRoutes.complaints,
        builder: (context, state) =>
            ComplaintsManageScreen(viewModel: complaintsViewModel),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) =>
            OwnerProfileScreen(authViewModel: authViewModel),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationListScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationDetails,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return NotificationDetailsScreen(data: data);
        },
      ),
      GoRoute(
        path: AppRoutes.tenantDetails,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return TenantDetailsScreen(data: data);
        },
      ),
      GoRoute(
        path: AppRoutes.pendingRentDetails,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return PendingRentDetailsScreen(data: data);
        },
      ),
      GoRoute(
        path: AppRoutes.recordPayment,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return CollectRentSheet(viewModel: ledgerViewModel, data: data);
        },
      ),
      GoRoute(
        path: AppRoutes.pendingRentOverview,
        builder: (context, state) => const PendingRentOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.overdueRent,
        builder: (context, state) => const OverdueRentScreen(),
      ),
      GoRoute(
        path: AppRoutes.dueSoon,
        builder: (context, state) => const DueSoonScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}
