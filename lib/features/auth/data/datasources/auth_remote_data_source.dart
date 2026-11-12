import 'package:dio/dio.dart';

import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;

      return UserModel.fromJson(data);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      final message = responseData is Map
          ? responseData['message']?.toString()
          : null;

      throw Exception(message ?? e.message ?? 'Login gagal');
    }
  }
}
