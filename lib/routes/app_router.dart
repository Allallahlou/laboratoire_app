import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/patients/patients_list_screen.dart';
import '../presentation/screens/patients/patient_form_screen.dart';
import '../presentation/screens/patients/patient_detail_screen.dart';
import '../presentation/screens/analyses/analyses_list_screen.dart';
import '../presentation/screens/analyses/demande_form_screen.dart';
import '../presentation/screens/results/results_entry_screen.dart';
import '../presentation/screens/stock/stock_screen.dart';
import '../presentation/screens/reports/reports_screen.dart';
import '../presentation/screens/payments/payments_screen.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    // ❌ حيدنا الـ redirect — SplashScreen هي اللي تدير navigation
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/patients',
        builder: (context, state) => const PatientsListScreen(),
      ),
      GoRoute(
        path: '/patients/new',
        builder: (context, state) => const PatientFormScreen(),
      ),
      GoRoute(
        path: '/patients/edit/:id',
        builder: (context, state) => PatientFormScreen(
          patientId: int.tryParse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/patients/detail/:id',
        builder: (context, state) => PatientDetailScreen(
          patientId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/analyses',
        builder: (context, state) => const AnalysesListScreen(),
      ),
      GoRoute(
        path: '/analyses/demande',
        builder: (context, state) => const DemandeFormScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsEntryScreen(),
      ),
      GoRoute(
        path: '/stock',
        builder: (context, state) => const StockScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
    ],
  );
}