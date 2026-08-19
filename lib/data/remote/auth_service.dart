import 'package:dio/dio.dart';
import 'api_service.dart';
import '../../core/constants/api_constants.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _api.dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await _api.dio.post(ApiConstants.register, data: data);
    return response.data;
  }
}
