class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';

  static const String login = '$apiVersion/auth/login';
  static const String register = '$apiVersion/auth/register';
  static const String patients = '$apiVersion/patients';
  static const String analyses = '$apiVersion/analyses';
  static const String demandes = '$apiVersion/demandes';
  static const String resultats = '$apiVersion/resultats';
  static const String stock = '$apiVersion/stock';
  static const String dashboard = '$apiVersion/dashboard/stats';
}
