import 'package:dio/dio.dart';
import '../../data/local/storage_service.dart';

class ApiClient {
  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();

  late final Dio dio;

  // Android emulator uses 10.0.2.2 to reach host localhost
  // For real device on same network, use your machine's IP
  static const String baseUrl = 'https://63mnglpv.asse.devtunnels.ms:8080';

  ApiClient._() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = StorageService.instance.accessToken;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }
}
