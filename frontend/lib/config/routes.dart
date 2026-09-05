import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/student/dashboard_screen.dart';
import '../screens/student/create_referral_screen.dart';
import '../screens/student/referral_detail_screen.dart';
import '../screens/student/my_referrals_screen.dart';
import '../screens/faculty/faculty_dashboard_screen.dart';
import '../screens/faculty/referral_queue_screen.dart';
import '../screens/faculty/assign_location_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Student routes
      GoRoute(
        path: '/student/dashboard',
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: '/student/create-referral',
        builder: (context, state) => const CreateReferralScreen(),
      ),
      GoRoute(
        path: '/student/my-referrals',
        builder: (context, state) => const MyReferralsScreen(),
      ),
      GoRoute(
        path: '/student/referral/:id',
        builder: (context, state) => ReferralDetailScreen(
          referralId: state.pathParameters['id']!,
        ),
      ),

      // Faculty routes
      GoRoute(
        path: '/faculty/dashboard',
        builder: (context, state) => const FacultyDashboardScreen(),
      ),
      GoRoute(
        path: '/faculty/referral-queue',
        builder: (context, state) => const ReferralQueueScreen(),
      ),
      GoRoute(
        path: '/faculty/assign-location/:id',
        builder: (context, state) => AssignLocationScreen(
          referralId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}
