import 'package:dio/dio.dart';
import '../../data/local/storage_service.dart';

class ApiClient {
  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();

  late final Dio dio;

  // Android emulator uses 10.0.2.2 to reach host localhost
  // For real device on same network, use your machine's IP
  static const String baseUrl = 'https://api.memore.vn';

  ApiClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(
          seconds: 60,
        ), // Tăng timeout cho upload ảnh
        sendTimeout: const Duration(seconds: 60), // Thêm sendTimeout cho upload
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.instance.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print('📡 API Request: ${options.method} ${options.path} - Token: ${token.substring(0, 20)}...');
          } else {
            print('⚠️ API Request: ${options.method} ${options.path} - NO TOKEN!');
          }
          handler.next(options);
        },
        onError: (error, handler) {
          print('❌ API Error: ${error.requestOptions.method} ${error.requestOptions.path}');
          print('   Status: ${error.response?.statusCode}');
          print('   Message: ${error.message}');
          if (error.response?.statusCode == 401) {
            print('   🔒 Authentication failed - Token may be expired or invalid');
          }
          handler.next(error);
        },
      ),
    );
  }
}
