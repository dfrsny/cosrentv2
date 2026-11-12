import 'package:dio/dio.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../core/network/dio_client.dart';

class Injection {
  static final Dio dio = DioClient.create();

  static final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource(
    dio,
  );

  static final AuthRepositoryImpl authRepository = AuthRepositoryImpl(
    authRemoteDataSource,
  );

  static final LoginUseCase loginUseCase = LoginUseCase(authRepository);
}
